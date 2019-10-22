##################################################################################################
# CIT480 - Group Project 1                                                                       #
# Team Name: NovaProspekt                                                                        #
# Team Members: Vlad Shtyrts, Dustin Redmon, Viktar Mizeryia                                     #
# Description: Web server using terraform and ansible                                            #
# https://novaprospekt.xyz/                                                                      #
##################################################################################################
# 1. Features
#  - Hosted on AWS
#  - Infrastructure setup using Terraform and Ansible
#  - VPC with 1 public and 3 private subnets 
#  - Uses EC2 to host server and site files on private subnets
#  - Uses Route53 DNS for name resolution and traffic management
#  - Uses NameCheap for the domain name
#  - Uses ACM for TLS/SSL certification for site security and encryption
#  
# 2. Installation
#  - Clone project into user home directory - https://github.com/dustinredmon/NovaProspekt-Project1.git
#  - run ansible-playbook --connection=localhost ~/NovaProspekt-Project1/ansible/setup.yml #Edit this to apply with terraform
#
# 3. Contribute and Contact
#  - Github: https://github.com/qusad/NovaProspekt-Project0
#  - Vlad Shtyrts: vlad.shtyrts.599@my.csun.edu
#  - Dustin Redmon: dustin.redmon.39@my.csun.edu
#  - Viktar Mizeryia: viktar.mizeryia.33@my.csun.edu
#
# 4. LICENSE
#  - GNU GENERAL PUBLIC LICENSE
#
