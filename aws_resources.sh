#!/bin/bash

# Set the AWS profile for authentication
export AWS_PROFILE=default

# Environment variables
ENVIRONMENT=$1

# Function to check the number of arguments
check_num_of_args() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <environment>"
        exit 1
    fi
}

# Function to activate the infrastructure environment
activate_infra_environment() {
    if [ "$ENVIRONMENT" == "local" ]; then
        echo "Running script for Local Environment..."
    elif [ "$ENVIRONMENT" == "testing" ]; then
        echo "Running script for Testing Environment..."
    elif [ "$ENVIRONMENT" == "production" ]; then
        echo "Running script for Production Environment..."
    else
        echo "Invalid environment specified. Please use 'local', 'testing', or 'production'."
        exit 2
    fi
}


create_s3_buckets() {
    company="datawise"
    departments=("Marketing" "Sales" "HR" "Operations" "Media")

    for department in "${departments[@]}"; do
        bucket_name="${company}-${department}-$(date +'%Y%m%d%H%M%S')"
        echo "Company: $company, Department: $department, Bucket Name: $bucket_name"

        # Attempt to create bucket
        aws s3api create-bucket \
            --bucket "$bucket_name"mary" \
            --region "eu-west-2" \
            --create-bucket-configuration LocationConstraint="eu-west-2" &> debug.log

        # Check the result
        if [ $? -eq 0 ]; then
            echo "S3 bucket '$bucket_name' created successfully."
        else
            echo "Failed to create S3 bucket '$bucket_name'. Check debug.log for details."
        fi
    done
}
