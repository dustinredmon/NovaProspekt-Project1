
##################################################################################################
# CIT480 - Group Project 1                                                                       #
# Team Name: NovaProspekt                                                                        #
# Team Members: Vlad Shtyrts, Dustin Redmon, Viktar Mizeryia                                     #
# Description: Web server using terraform and ansible                                            #
# https://novaprospekt.xyz/                                                                      #
##################################################################################################

# 1. Features
# Project 1: build simple LAMP stack and deploy weather app using ansible 

This ansible playbook installes LAMP stack and weather application on servers specified in [hosts] section of playbook. Using dynamic inventories ansible discovers available ec2 instances and compares their tag_Name with specified in playbook. In case of match, ansible establish ssh connection to remote host (via ssh forwarding) and applies playbook to hosts.

This playbook was tested on macOS local host, and Ubuntu remote host.

This ansible playbook implements **dynamic inventory**. Out of two options to implement **DI** (dynamic plugins and dynamic scripts) we used dynamic scripts: ec2.ini (configuration file) ec2.py (script). Download link: https://github.com/ansible/ansible/blob/devel/contrib/inventory/brook.py Store files in /etc/ansible/ folder.

Boto is an Amazon AWS SDK for python. Ansible internally uses Boto to connect to Amazon EC2 instances and hence you need Boto library in order to run Ansible on your laptop/desktop.

Requirement of the project is application servers to be in private subnets. This requires additional configuration of ec2.ini and configuration of ssh **config** file to allow ssh forwarding. Before to run this playbook following modifications need to be done:

# 2. Installation

### ec2.ini configuration file:
According to this requirement following changes needed in default configuration of ec2.ini:

  -   Uncomment following statement:
  
          hostname_variable = tag_Name
      
      This will allow to use ec2 variables (tag_Name)
      
  -   For server inside a VPC, using DNS names may not make sense. When an instance has 'subnet_id' set, following variable is used. If the subnet is public, setting this to 'ip_address' will return the public IP address. For instances in a private subnet, this should be set to 'private_ip_address', and Ansible must be run from within EC2.
  
          vpc_destination-variable = private_ip_address

  -   To successfully make an API call to AWS, you will need to configure Boto (the Python interface to AWS). The AWS credentials file could be used as a config file. Uncomment and specify profile name "nova" used for credntials associated with pject infrastructure (aws profile contains access keys):
  
          boto_profile = nova
      
### ssh **config** file (ssh forwarding):

Following command allows ssh connection via bastion host to a server in private subnet:

      ssh -i /path/to/key ubuntu@ip_address -o "proxycommand ssh -W %h:%p -i /path/to/key ubuntu@ip_address"
      
Alternatively ssh **config** file can be mofified:
      
      Host 10.0.4.62  //destination ip_address
        User ubuntu   //user
        IdentityFile ~/.ssh/id_rsa //path to key
        ProxyCommand ssh -q -W %h:%p 34.214.69.208 //proxycommand %h(host):%p(port) ip_address_bastion

      Host 10.0.5.193
        User ubuntu
        IdentityFile ~/.ssh/id_rsa
        ProxyCommand ssh -q -W %h:%p 34.214.69.208

      Host 34.214.69.208
        User ubuntu
        IdentityFile ~/.ssh/id_rsa
        Hostname 34.214.69.208
        ForwardAgent yes      //specifies if connection of current user will be forwareded to remote machine
        ControlMaster auto    //enables multiple sessions over single network connection
        ControlPath ~/.ssh/control-%%r@%%h:%%p  //path to location where to store control socket
        ControlPersist 5m //leaves master connection for specified time
        StrictHostKeyChecking no
      
      
### ansible.cfg modification:

      [inventory]
      inventory = /etc/ansible/ec2.py
     
# 3. Contribute and Contact
#  - Github: https://github.com/dustinredmon/NovaProspekt-Project1
#  - Vlad Shtyrts: vlad.shtyrts.599@my.csun.edu
#  - Dustin Redmon: dustin.redmon.39@my.csun.edu
#  - Viktar Mizeryia: viktar.mizeryia.33@my.csun.edu
#
# 4. LICENSE
#  - GNU GENERAL PUBLIC LICENSE
#



