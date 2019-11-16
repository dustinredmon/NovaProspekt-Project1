######################### variables #####

variable "ssh_key_encoding" {
   type = string
   default = "SSH"
}

########################## profider ######
/*provider "aws" {
   region = "us-west-2"
}*/

##################### setup USERS section ############################

#iam users
resource "aws_iam_user" "user" {
   count = 3
   name = "User${count.index+2}"
   force_destroy = true
}

#ssh keys for all users
resource "aws_iam_user_ssh_key" "ssh" {

  count = 3
  username   = "${aws_iam_user.user.*.id[count.index]}"
  encoding   = var.ssh_key_encoding
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41"#var.ssh_public_key
}

#group membership for users
resource "aws_iam_group_membership" "user_membership" {
   name = "group-assignment"
   count = 2
   users = "${aws_iam_user.user.*.id[*]}"
   group = "${aws_iam_group.admins.name}"

}

############ end of USERS section #####################


#################### setup POLICIES section #####################

#administrators group policy
resource "aws_iam_group_policy" "admins_policy" {
   name = "admin_policy"
   group = "${aws_iam_group.admins.id}"
   policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
   {
      "Action": ["*"],
      "Effect": "Allow",
      "Resource": ["*"]
   }
   ]
}
EOF
}

#user group policy
resource "aws_iam_group_policy" "usr_policy" {
   name = "user_policy"
   group = "${aws_iam_group.users.id}"
   policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
   {
      "Action": ["*"],
      "Effect": "Allow",
      "Resource": ["*"]
   }
   ]
}
EOF
}

############################## end of POLICIES section ##############


####################### setup GROUPS section ##################
#Administrator group
resource "aws_iam_group" "admins" {
   name = "administrators"
   path = "/groups/"
}

#user group
resource "aws_iam_group" "users" {
   name = "users"
   path = "/groups/"
}


##################### end of GROUPS section ####


############ lambda_function_policy #####
resource "aws_iam_group_policy" "lambda_policy" {
   name = "lambda_policy"
   group = "${aws_iam_group.admins.id}"
   policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
       ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
     },
     {
      "Effect":"Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
       ],
      "Resource": "*"
     }
   ]
}
EOF
}
########## lambda_role ###############
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
