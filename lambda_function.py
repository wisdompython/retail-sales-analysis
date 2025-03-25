import os
import boto3
import requests
import json
from io import BytesIO
import zipfile

def lambda_handler(event, context):
    # Dataset configuration
    dataset_owner = "mohammadtalib786"
    dataset_name = "retail-sales-dataset"
    download_url = f"https://www.kaggle.com/api/v1/datasets/download/{dataset_owner}/{dataset_name}"
    
    try:
        # Download dataset
        response = requests.get(
            download_url,
            auth=(os.environ['KAGGLE_USERNAME'], os.environ['KAGGLE_KEY']),
            timeout=30
        )
        response.raise_for_status()

        # Process ZIP file
        with zipfile.ZipFile(BytesIO(response.content)) as zip_file:
            csv_files = [f for f in zip_file.namelist() if f.endswith('.csv')]
            if not csv_files:
                raise ValueError("No CSV files found in dataset")
                
            s3 = boto3.client('s3')
            for csv_file in csv_files:
                with zip_file.open(csv_file) as file_data:
                    s3_key = f"raw/{csv_file}"
                    s3.upload_fileobj(
                        Fileobj=file_data,
                        Bucket=os.environ['S3_BUCKET_NAME'],
                        Key=s3_key
                    )
                # Trigger Glue job for each CSV
                glue_job_name=os.environ['GLUE_JOB_TRIGGER_NAME']

                glue = boto3.client('glue')
                input_s3_path = f's3://{os.environ["S3_BUCKET_NAME"]}/{s3_key}'
                # output_s3_path = f's3://{os.environ["S3_BUCKET_NAME"]}/processed/'

                glue.start_trigger(Name=glue_job_name)

        
        glue_message = f"Triggered Glue job: {glue_job_name} with input path: {input_s3_path}"
        file_message = f"Processed {len(csv_files)} CSV files"

        return {
            'statusCode': 200,
            "body": json.dumps({
                "glue_message": glue_message,
                "file_message": file_message
            })
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: {str(e)}"
        }