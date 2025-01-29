resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-policy"
  description = "Policy for pushing Docker images to ECR"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Effect   = "Allow"
        Resource = "${aws_ecr_repository.my_repository.arn}/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_attachment" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}
