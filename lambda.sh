#!/usr/bin/env bash
echo "Inside lambda.sh file"
pwd
ls -al
MyLambda=$(aws lambda list-functions --region us-east-1 --query 'Functions[0].FunctionName' --output text)
aws lambda update-function-code --zip-file=fileb://lambda-aws-ROOT.zip --region=us-east-1 --function-name=$MyLambda