resource "aws_iam_role" "service_role" {
    name = var.role_name
    assume_role_policy = var.role_json
    tags = {
        Name = var.role_name
    }
}

resource "aws_iam_policy_attachment" "attachment_policy" {
    name = var.policy_name
    roles = [aws_iam_role.service_role.id]
    policy_arn = var.policy_arn
} 