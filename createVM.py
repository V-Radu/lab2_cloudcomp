
import boto3

ec2 = boto3.client('ec2')

ec2Resource = boto3.resource('ec2')
ec2Resource.create_instances(MaxCount=1, MinCount=1,                            \
ImageId='ami-08d658f84a6d84a80',SecurityGroupIds=['sg-026b7617f05cf8cb6'],      \
SecurityGroups=['launch-wizard-1'], KeyName='RaduAmazoneKey',InstanceType='t2.micro')


print("\n  EC2 Instances description *****\n")
response = ec2.describe_instances()
print(response)
