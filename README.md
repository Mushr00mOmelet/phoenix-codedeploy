# PhoenixCodedeploy

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.

## Helpful Notes for Setup

To add the AWS CLI to a non Amazon Linux EC2 instance, place the following snippet of code in the User Data section, under "Advanced Settings" when you set up your EC2 instance or create a launch configuration.

Note the region-specific config, make sure that those values are in line with the AWS region you primarily use.

```#!/bin/bash
yum -y update
yum install -y ruby
yum install -y aws-cli
cd /home/ec2-user
aws s3 cp s3://aws-codedeploy-us-east-1/latest/install . --region us-east-1
chmod +x ./install
./install auto
```
