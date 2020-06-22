#!/bin/bash
  ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
 TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\", \"Principal\": { \"AWS\": \"arn:aws:iam::${ACCOUNT_ID}:root\" }, \"Action\": \"sts:AssumeRole\" } ] }"
 aws iam create-role --role-name UdacityFlaskDeployCBKubectlRole --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'
 echo '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Action": "eks:Describe*", "Resource": "*" } ] }' > ./tmp/iam-role-policy
 aws iam put-role-policy --role-name UdacityFlaskDeployCBKubectlRole --policy-name eks-describe --policy-document file://./tmp/iam-role-policy
 aws iam attach-role-policy --role-name UdacityFlaskDeployCBKubectlRole --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
 aws iam attach-role-policy --role-name UdacityFlaskDeployCBKubectlRole --policy-arn arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess
 aws ssm put-parameter --name JWT_SECRET --value "YourJWTSecret" --type SecureString --overwrite
 aws eks --region us-east-2 update-kubeconfig --name simple-jwt-api


