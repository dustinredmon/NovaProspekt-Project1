##################################################################################################
# CIT480 - Group Project 1                                                                       #
# Team Name: NovaProspekt                                                                        #
# Team Members: Vlad Shtyrts, Dustin Redmon, Viktar Mizeryia                                     #
# Description: Web server using terraform and ansible                                            #
# https://novaprospekt.xyz/                                                                      #
##################################################################################################
# 1. Features
#  - Lambda functions to turn EC2 instances on and off
#  - Hosted on AWS CloudWatch
#  
# 2. Installation
#  - Clone project into user home directory - https://github.com/dustinredmon/NovaProspekt-Project1.git
#  - Locate the startEC2.py and stopEC2.py
#  - Copy code or import into AWS Lambda console
#  - Open CloudWatch console
#  - Select Rules under the Events tab
#  - Create event and choose Schedule
#  - Select the desired cron expression(start - 0 0 6 ? * FRI * | stop - 0 0 6 ? * SUN *)
#  - Select Targets and choose Add target
#  - Select the function and add an appropriate name
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
