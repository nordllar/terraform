import json
import boto3
from io import BytesIO
import zipfile
import os
from urllib.parse import unquote_plus


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    output_bucket = os.environ.get('save_to_bucket')
    output_prefix = os.environ.get('save_to_prefix')
    s3_resource = boto3.resource('s3')

    # If the event is coming from S3
    if event['Records'][0]['eventSource'] == 'aws:s3':
        bucket = event['Records'][0]['s3']['bucket']['name']
        object_key = event['Records'][0]['s3']['object']['key']

    # If the event is coming from SQS
    elif event['Records'][0]['eventSource'] == 'aws:sqs':
        s3_event_str = event['Records'][0]['body']
        s3_event = json.loads(s3_event_str)
        bucket = s3_event['Records'][0]['s3']['bucket']['name']
        object_key = s3_event['Records'][0]['s3']['object']['key']
    else:
        raise ValueError('Unknown event source.')

    # In the S3 event, space is replaced by '+', so change it back for the boto3 calls
    object_key = unquote_plus(object_key)
    # print('object_key', object_key)

    prefix = '/'.join(object_key.split('/')[1:-1])
    if prefix:
        prefix = f'{output_prefix}{prefix}'
    else:
        prefix = output_prefix.split('/')[0]

    file = s3_resource.Object(bucket_name=bucket, key=object_key)
    buffer = BytesIO(file.get()['Body'].read())

    if str(object_key).endswith('.zip'):
        # unpacking
        z = zipfile.ZipFile(buffer)
        for filename in z.namelist():
            try:
                s3_resource.meta.client.upload_fileobj(
                    z.open(filename),
                    Bucket=output_bucket,
                    Key=f'{prefix}/{filename}')
            except Exception as e:
                print(e)
    else:
        filename = object_key.split('/')[-1]
        try:
            s3_resource.meta.client.upload_fileobj(
                buffer,
                Bucket=output_bucket,
                Key=f'{prefix}/{filename}')
        except Exception as e:
            print(e)
    return



