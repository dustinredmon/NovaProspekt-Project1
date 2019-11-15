##################################################################################################
# CIT480 - Group Project 1                                                                       #
# Team Name: NovaProspekt                                                                        #
# Team Members: Vlad Shtyrts, Dustin Redmon, Viktar Mizeryia                                     #
# Description: Web server using terraform and ansible                                            #
# https://novaprospekt.xyz/                                                                      #
##################################################################################################
# 1. Features
#  - Terraform function to setup AWS infrastructure
#  - Sets up the AWS VPC, Internet Gateway, NAT Gateway, Subnets, Private EC2 Instances, 
#    Bastion EC2 Instance, Route53 DNS, SSL/TSL Certs with ACM, Security Groups, Load Balancer, 
#    Users, and other necessary features.
#
# 2. Pre-requisites
#   - Install and Configure
#      Ansible:           https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
#      Terraform:         https://learn.hashicorp.com/terraform/getting-started/install.html
#      Dynamic Inventory: https://github.com/lesmono/devops-starter/tree/master/ansible/inventory
#      AWS-CLI:           https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
#
# 2. Installation
#  - Clone project into user home directory - https://github.com/dustinredmon/NovaProspekt-Project1.git
#  - Locate the /tf/s3 folder 
#  - Run terraform init to initialize the folder as the working directory prior to creating the S3 bucket
#  - Run terraform apply 
#  - Return to /tf folder and run terraform init and terraform apply again. This will build the infrastructure
#
#
# 3. Contribute and Contact
#  - Github: https://github.com/dustinredmon/NovaProspekt-Project1
#  - Vlad Shtyrts: vlad.shtyrts.599@my.csun.edu
#  - Dustin Redmon: dustin.redmon.39@my.csun.edu
#  - Viktar Mizeryia: viktar.mizeryia.33@my.csun.edu
#
# 4. LICENSE
#  - GNU GENERAL PUBLIC LICENSE
#

