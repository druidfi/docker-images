# See https://docs.microsoft.com/en-us/azure/mysql/howto-configure-ssl
ADD https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem /opt/ssl/

RUN <<EOF
#
# Add user to www-data group
#
adduser ${DEFAULT_USER} www-data
#
# Add user to sudoers
#
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
#
# Quiet down Sudo
#
echo "Set disable_coredump false" > /etc/sudo.conf
#
# Create app directory
#
mkdir -p ${APP_PATH}
chown ${DEFAULT_USER}:${DEFAULT_USER} ${APP_PATH}
#
# Set permissions
#
chmod 0644 /opt/ssl/BaltimoreCyberTrustRoot.crt.pem
EOF
