#!/bin/sh
# shellcheck disable=SC2086

DATA_PATH="/data/"
S3CMD_BIN="/usr/bin/s3cmd"

if [ -n "${REGION}" ]; then
  $S3CMD_BIN="${$S3CMD_BIN} --region=${REGION}"
fi

if [ -n "${ACCESS_KEY}" ]; then
  $S3CMD_BIN="${$S3CMD_BIN} --access_key=${ACCESS_KEY}"
fi

if [ -n "${SECRET_KEY}" ]; then
  $S3CMD_BIN="${$S3CMD_BIN} --secret_key=${SECRET_KEY}"
fi

if [ "$1" = 'conf' ]; then
    echo -e "\n\nsc3cmd:" "$S3CMD_BIN" "\n\n"
    cat /root/.s3cfg
    exit 0
fi

: "${S3_PATH:?"S3_PATH env variable is required"}"

echo "Job started: $(date)"

$S3CMD_BIN sync --recursive --no-preserve $DATA_PATH $S3_PATH

echo "Job finished: $(date)"
