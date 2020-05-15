# EC2 & S3 POC

## Task Requirements
In this implementation, the following tasks were required to be completed.

- Create an EC2 instance
- Run a web service on the EC2. For example, Apache.
- Create a S3 bucket that will contain HTML code files
- Allow EC2 instance permission to access the S3 bucket and download the HTML file.
- The HTML file should get served on the Apache server when EC2's IP gets hit.

### Pre Reqs
- Only the EC2 instance should have access to the S3 bucket and no other resource.

## Solution Implemented
I implemented this task in the following manner

- Created an IAM role with `ReadOnly` access to the S3 bucket
- When creating the S3 bucket, I updated its bucket policy to deny all actions to the bucket and its resources to all other resources expect those which I had exempted.
- Created a script to install Apache and AWS CLI inside the EC2 instance.
- Created a cron job that runs every minute and pulls in the main `index.html` file from S3 and places it in `/var/www/html/`. This way any changes to the `index.html` file are instantly visible on the server.
