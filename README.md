##################################################################################################
# CIT480 - Group Project 1                                                                       #
# Team Name: NovaProspekt                                                                        #
# Team Members: Vlad Shtyrts, Dustin Redmon, Viktar Mizeryia                                     #
# Description: Web server infrastructure setup using terraform and ansible for weather app       #
# https://novaprospekt.xyz/                                                                      #
##################################################################################################
# 1. Features
#  - Hosted on AWS.
#  - Remote infrastructure setup using Terraform and Ansible.
#  - VPC with 3 public and 2 private subnets.
#  - Public subnets host the Bastion, Elastic Load Balancer, and Nat Instance.
#  - Private subnets host EC2 instances running Ubuntu for the weather app.
#  - Both the ELB and the private servers are available in diferent availability zones.
#  - Uses Route53 DNS for name resolution and traffic management.
#  - Uses prexisting hosted zone for SOA and NS records already registered with NameCheap for the domain name.
#  - Uses ACM for TLS/SSL certification for site security and encryption.
#  - SSL Certificate is attached to the ELB.
#  - ELB takes incoming traffic on port 80 and 443 and redirects it to port 80 on the private servers.
#  - HTTP correctly redirects to HTTPS using a redirect in the apache conf files.
#  - LAMDA function runs the servers on the weekend to cut server costs.
#  - Webservers on the private network only accept ssh connections from the bastion.
#  - Admins can ssh into the bastion on the bastion public subnet to gain access to the private servers.
#  - Fail2ban is running on the bastion to prevent brute force attacks.
#  - AWS Backups create snapshots of EBS volumes and DynamoDB tables on a weekly basis every Monday at 1am.
#
# 2. Installation
#  Infrastructure install:
#  - Clone project into user home directory - https://github.com/dustinredmon/NovaProspekt-Project1.git
#  - Locate the /tf/s3 folder 
#  - Run terraform init to initialize the folder as the working directory prior to creating the S3 bucket
#  - Run terraform apply 
#  - Return to /tf folder and run terraform init and terraform apply again. This will build the infrastructure
#
#  Ansible install:
#  - see ansible readme
#
#  LAMDA function install:
#  - Locate the startEC2.py and stopEC2.py
#  - Copy code or import into AWS Lambda console
#  - Open CloudWatch console
#  - Select Rules under the Events tab
#  - Create event and choose Schedule
#  - Select the desired cron expression(start - 0 0 6 ? * FRI * | stop - 0 0 6 ? * SUN *)
#  - Select Targets and choose Add target
#  - Select the function and add an appropriate name
#
# 3. Contributors and Contact
#  - Github: https://github.com/qusad/NovaProspekt-Project0
#  - Vlad Shtyrts: vlad.shtyrts.599@my.csun.edu
#  - Dustin Redmon: dustin.redmon.39@my.csun.edu
#  - Viktar Mizeryia: viktar.mizeryia.33@my.csun.edu
#
# 4. LICENSE
#  - GNU GENERAL PUBLIC LICENSE
#
