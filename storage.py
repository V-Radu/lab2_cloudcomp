import boto3
import logging
from botocore.exceptions import ClientError


def create_bucket(bucket_name, bucket_location):
    s3 = boto3.client('s3')
    try:
        s3.create_bucket(Bucket=bucket_name, CreateBucketConfiguration=bucket_location)
    except ClientError as e:
        #logging.error(e)
        print('Bucket not created')
        print(e)
    print('Bucket created')

def display_buckets():
    s3 = boto3.client('s3')
    responce = s3.list_buckets()

    print('Existing buckets:')
    for bucket in responce['Buckets']:
        print(f'    {bucket["Name"]}')

def upload_file(file_name, bucket, object_name=None):
    # Upload a file to S3 bucket
    if object_name is None:
        object_name = file_name

    s3_client = boto3.client('s3')
    try:
         response = s3_client.upload_file(file_name, bucket, object_name)
    except ClinetError as e:
        logging.error(e)
        print('File not uploaded')
        return False
    print('File uploaded succesfully')



permission='public-read'
name = 'storageblob33'
location = {'LocationConstraint': 'eu-west-1'}
fileName = './myText.txt'

if __name__=='__main__':
    create_bucket(name, location)
    display_buckets()
    upload_file(fileName, name)

