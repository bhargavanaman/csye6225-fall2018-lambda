#!/usr/bin/env bash
echo "Inside lambda.sh file "
pwd
ls -al
MyLambda=$(aws lambda list-functions --region us-east-1 --query 'Functions[0].FunctionName' --output text)
aws lambda update-function-configuration --function-name $MyLambda --memory-size 200 --timeout 300

echo "Fetching domain name from Route 53"
DOMAIN_NAME=$(aws route53 list-hosted-zones --query HostedZones[0].Name --output text)
DOMAIN_NAME="${DOMAIN_NAME%?}"
echo "DOMAIN_NAME:- $DOMAIN_NAME"

LAMBDABUCKET="lambda.$DOMAIN_NAME"
aws lambda update-function-code --region=us-east-1 --function-name=$MyLambda --s3-bucket $LAMBDABUCKET --s3-key "lambda-dpk-nmn.zip"
#aws lambda update-function-code --zip-file=fileb://lambda_artifact/lambda-dpk-nmn.zip --region=us-east-1 --function-name=$MyLambda