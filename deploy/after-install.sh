#!/bin/bash

set -e

# Find out from CodeDeploy what environment we are in by parsing the APPLICATION_NAME
ENVIRONMENT=`echo "$APPLICATION_NAME" | cut -d '-' -f 1 | tr A-Z a-z`
# Put the environment in the log
echo "Customizing environment: $ENVIRONMENT"

# Setup variables depending on what environment
case $ENVIRONMENT in
    squirtle)
        S3=squirtle-s3-buckets-appconfigbucket-hsb31mlv52sx
        export MIX_ENV=squirtle
    ;;
    charmander)
        S3=charmander-s3-buckets-appconfigbucket-159qk8jolnz49
        export MIX_ENV=charmander
    ;;
    bulbasaur)
        S3=bulbasaur-s3-buckets-appconfigbucket-19b4kyxchtk7b
        export MIX_ENV=bulbasaur
    ;;
    production)
        S3=production-s3-buckets-appconfigbucket-wyvb0uh5uocb
        export MIX_ENV=prod
    ;;
    *)
        echo "Error: undefined environment: $ENVIRONMENT"
        exit 1
    ;;
esac

SOURCE_DIR=/opt/phoenix-codedeploy/deploy

# Logging
awk -v env="$ENVIRONMENT" '{ gsub(/ENV_VALUE/, env); print }' \
    "$SOURCE_DIR"/awslogs.conf >/tmp/awslogs.conf
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
python ./awslogs-agent-setup.py \
    --non-interactive \
    --region `ec2metadata --availability-zone | rev | cut -c 2- | rev` \
    --configfile /tmp/awslogs.conf
service awslogs restart

# Monitoring
# relies on being run in /home/root
curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
unzip -o CloudWatchMonitoringScripts-1.2.1.zip
install -m 644 "$SOURCE_DIR"/awsmoncron /etc/cron.d/awsmon

# Move into the app directory
cd /opt/phoenix-codedeploy

# Pull in secrets from S3 Bucket
aws --region=us-east-1 s3 cp s3://$S3/monica-app-$ENVIRONMENT.secret.exs /opt/phoenix-codedeploy/config/$MIX_ENV.secret.exs

# Copy over the upstart script, downloading and setting variables as needed
export MANDRILL_KEY=CfXexuUzxPcLKR3CuYaw4A  # fallback testing key
aws --region=us-east-1 s3 cp s3://$S3/monica-app-$ENVIRONMENT.secrets.sh /opt/phoenix-code-deploy/deploy/secrets.sh || true
test -f /opt/phoenix-cd-demo/deploy/secrets.sh && source /opt/phoenix-codedeploy/deploy/secrets.sh
awk -v mix="$MIX_ENV" -v mandrill="$MANDRILL_KEY" '{
    gsub(/MIX_ENV_VALUE/, mix)
    gsub(/MANDRILL_KEY_VALUE/, mandrill)
    print
}' /opt/phoenix-codedeploy/deploy/monica-app-upstart.conf >/etc/init/monica-app.conf

export HOME=/root
mix local.hex --force
yes | head -n 1000 | mix deps.get
yes | head -n 1000 | mix deps.compile
yes | head -n 1000 | mix compile
yes | head -n 1000 | mix ecto.migrate
yes | head -n 1000 | mix phoenix_codedeploy.insert_seeds
mix phoenix.digest -o _build/prod/lib/phoenix_codedeploy/priv/static/ web/static
