# 1. Create a CodeCommit Repository
resource "aws_codecommit_repository" "tf_repo" {
	repository_name = var.repo_name
	description     = "A Terraform Working Repository"
}

# 2. Create S3 Bucket to Deploy our React App
resource "aws_s3_bucket" "s3_bucket" {
	bucket = var.bucket_name
	acl    = var.access_level
	website {
		index_document = "index.html"
		error_document = "error.html"
	}
	tags = {
		Name        = var.bucket_name
	}
}

# Grant Public Read Access with the S3 Policy
resource "aws_s3_bucket_policy" "source_bucket_policy" {
    bucket = aws_s3_bucket.s3_bucket.id
    policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "PublicReadGetObject",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "${aws_s3_bucket.s3_bucket.arn}/*"
		}
	]
}
POLICY
}

# 3. Create a S3 Bucket for CodePipeline Artifact Storage
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "cp-dg-bucket"
  acl    = "private"
}

# 3. Create IAM Policy & Role for CodeBuild to Access S3 Buckets (CodePipeline + Main S3)
resource "aws_iam_policy" "s3_codebuild_policy" {
  name        = var.policy_name
  path        = "/"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Resource": [
				"*"
			],
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents"
			]
		},
		{
			"Sid": "CodeCommitPolicy",
			"Effect": "Allow",
			"Action": [
				"codecommit:GitPull"
			],
			"Resource": [
				"${aws_codecommit_repository.tf_repo.arn}"
			]
		},
		{
			"Effect": "Allow",
			"Resource": [
					"${aws_s3_bucket.codepipeline_bucket.arn}/*"
			],
			"Action": [
				"s3:PutObject",
				"s3:GetObject",
				"s3:GetObjectVersion",
				"s3:GetBucketAcl",
				"s3:GetBucketLocation"
			]
		},
		{
			"Action": [ 
				"s3:PutObject"
			],
			"Resource": [
				"${aws_s3_bucket.s3_bucket.arn}/*"
			],
			"Effect": "Allow"
		}
	]
}
EOF
}

module "s3_codebuild_role" {
    source = "../../modules/iam_role"
    role_name = var.role_name
    role_json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
    policy_name = var.policy_name
    policy_arn = aws_iam_policy.s3_codebuild_policy.arn
}

# 4. Create CodeBuild Project
resource "aws_codebuild_project" "s3_codebuild" {
	name          = var.project_name
	description   = var.cb_description
	build_timeout = var.build_timeout
	service_role  = module.s3_codebuild_role.arn

	artifacts {
		type = var.artifact_type
		location = var.bucket_name
	}

	environment {
		compute_type                = var.env_compute_type
		image                       = var.env_image
		type                        = var.env_type
		image_pull_credentials_type = var.env_image_pull_credentials_type
		
		environment_variable {
			name  = "DeployBucket"
			value = var.bucket_name
		}
	}

	logs_config {
		cloudwatch_logs {
			group_name  = "log-group"
			stream_name = "log-stream"
		}
	}

	source {
		type            = var.source_type
		location        = aws_codecommit_repository.tf_repo.clone_url_http
		git_clone_depth = 1

		git_submodules_config {
			fetch_submodules = true
		}
	}
}

# 6. Create Policy & IAM Role for CodePipeline
resource "aws_iam_policy" "codepipeline_policy" {
  name        = var.cp_policy_name
  path        = "/"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
		{
      "Effect":"Allow",
      "Action": [
        "iam:ListRoles",
				"iam:PassRole"
      ],
      "Resource": "*"
    },
		{
      "Effect":"Allow",
      "Action": [
				"codecommit:CancelUploadArchive",
				"codecommit:GetBranch",
				"codecommit:GetCommit",
				"codecommit:GetUploadArchiveStatus",
				"codecommit:UploadArchive"
      ],
      "Resource": [
				"${aws_codecommit_repository.tf_repo.arn}"
			]
    },
		{
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": [
				"${aws_codebuild_project.s3_codebuild.arn}"
			]
    }
	]
}
EOF
}

module "codepipeline_role" {
    source = "../../modules/iam_role"
    role_name = var.cp_role_name
    role_json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
    policy_name = var.cp_policy_name
    policy_arn = aws_iam_policy.codepipeline_policy.arn
}

# 7. Create a CodePipeline

resource "aws_codepipeline" "codepipeline" {
  name     = var.codepipeline_name
  role_arn = module.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = var.cp_artifact_type
  }

  stage {
    name = var.source_name

    action {
      name             = var.source_name
      category         = var.source_name
      owner            = var.owner
      provider         = var.source_provider
      version          = "1"
			output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = var.repo_name
        BranchName = var.branch_name
      }
    }
  }

  stage {
    name = var.build_name

    action {
      name             = var.build_name
      category         = var.build_name
      owner            = var.owner
      provider         = var.build_provider
			version          = "1"
			input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      configuration = {
        ProjectName = var.project_name
      }
    }
  }
}