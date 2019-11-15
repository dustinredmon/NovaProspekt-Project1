import boto3
region = 'us-west-2'
instances = ['i-0a72817988a16db2c', 'i-02aad44b5e68189d7', 'i-01f8a5f97da30c6d4']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
        ec2.start_instances(InstanceIds=instances)
            print('St your instances: ' + str(instances))
