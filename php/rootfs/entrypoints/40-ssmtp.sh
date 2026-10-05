#!/bin/bash

if [ ${SSMTP_MAILHUB+x} ]; then

  echo "- Prepare SSMTP conf..."

  sudo --preserve-env ep -v /etc/ssmtp/ssmtp.conf

fi

echo "- Prepare MSMTP conf in /etc/msmtprc..."

sudo --preserve-env ep -v /etc/msmtprc
