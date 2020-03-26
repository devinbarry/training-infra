from pprint import pprint
import boto3

ec2_client = boto3.client('ec2', region_name='us-east-1')

canonical = '099720109477'

images = ec2_client.describe_images(
    Filters=[
            {'Name': 'architecture', 'Values': ['x86_64', ]},
            {'Name': 'description', 'Values': ['*18.04*', ]},
        ],
    Owners=[canonical])

filtered_images = []

# REMOVE = ['EKS', 'Minimal', 'UNSUPPORTED', '2015', '2016', '2017', '2018', '2019']
REMOVE = ['EKS', 'Minimal', 'UNSUPPORTED', '2018', '2019']

for image in images['Images']:
    if "Description" not in image:
        continue
        # raise Exception('No image description!!')

    if not any(word in image["Description"] for word in REMOVE):
        filtered_images.append(image)

for image in filtered_images:
    # print(image["Description"])
    pprint(image)
