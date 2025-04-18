#!/bin/bash

# Function to create EC2 instances
create_ec2_instances() {
  ami_id="ami-0cd59ecaf368e5ccf"
  count=$2
  region=$3

  # Create EC2 instances using the aws cli
  aws ec2 run-instances --image-id $ami_id --instance-type t2.micro --count $count --region $region --key-name MyKeyPair

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
    echo "EC2 instances created successfully"
  else
    echo "Failed to create EC2 instances"
  fi
}

# Function to create S3 buckets
create_s3_buckets() {
  # Define the array of departments
  departments=("Marketing" "Sales" "HR" "Operations" "Media")

  # Loop through the departments array
  for department in "${departments[@]}"; do
    # Construct the S3 bucket name
    bucket_name="datawise-$department-Data-Bucket-$RANDOM"

    # Create the S3 bucket using the AWS CLI
    aws s3api create-bucket --bucket $bucket_name --region us-west-2

    # Check the exit status of the previous command
    if [ $? -eq 0 ]; then
      echo "S3 bucket $bucket_name created successfully"
    else
      echo "Failed to create S3 bucket $bucket_name"
    fi
  done
}

# Function to give permission to an S3 bucket
give_permission_to_s3_bucket() {
  bucket_name=$1
  user_or_group=$2
  permission=$3

  # Give permission to the S3 bucket using the AWS CLI
  aws s3api put-bucket-acl --bucket $bucket_name --grant-write $user_or_group --grant-read $user_or_group --grant-read-acp $user_or_group --grant-full-control $user_or_group

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
    echo "Permission granted to $user_or_group for S3 bucket $bucket_name"
  else
    echo "Failed to grant permission to $user_or_group for S3 bucket $bucket_name"
  fi
}

# Check the number of arguments
if [ $# -ne 3 ]; then
  echo "Usage: $0 <ami_id> <count> <region>"
  exit 1
fi

ami_id=$1
count=$2
region=$3

create_ec2_instances $ami_id $count $region
create_s3_buckets
