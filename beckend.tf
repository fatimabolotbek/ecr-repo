terraform {
   backend "s3" {
     bucket = "my-jenkins24"
     key = "ecs/terraform.tfstate"
     region = "us-west-1"
     
   }
}