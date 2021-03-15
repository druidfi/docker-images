#!/bin/sh
# shellcheck disable=SC2086

DATA_PATH="/data/"

: "${ACCESS_KEY:?"ACCESS_KEY env variable is required"}"
: "${SECRET_KEY:?"SECRET_KEY env variable is required"}"
REGION=${REGION:-eu-central-1}

S3CMD_BIN="/usr/bin/s3cmd --region=$REGION"
S3CMD_BIN="$S3CMD_BIN --access_key=$ACCESS_KEY"
S3CMD_BIN="$S3CMD_BIN --secret_key=$SECRET_KEY"

if [ "$1" = 'conf' ]; then
    echo -e "\n\nsc3cmd:" "$S3CMD_BIN" "\n\n"
    cat /root/.s3cfg
    exit 0
fi

: "${S3_PATH:?"S3_PATH env variable is required"}"

echo "Job started: $(date)"

$S3CMD_BIN sync --recursive --no-preserve $DATA_PATH $S3_PATH

echo "Job finished: $(date)"
