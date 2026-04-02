#!/bin/bash

if [ ${SSMTP_MAILHUB+x} ]; then

  echo "- Prepare SSMTP conf..."

  doas ep -v /etc/ssmtp/ssmtp.conf

fi

echo "- Prepare MSMTP conf in /etc/msmtprc..."

doas ep -v /etc/msmtprc
