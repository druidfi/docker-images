RUN <<EOF
#
# Set permissions on Composer home directory
#
mkdir -p ${COMPOSER_HOME}
chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${COMPOSER_HOME}
#
# Install Blackfire probe
#
curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/$(uname -m)/${PHP_SHORT_VERSION}
mkdir -p /tmp/blackfire
tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire
mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so
printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8307\n" > /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini
rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
test -f $(php -r "echo ini_get ('extension_dir');")/blackfire.so
test -f /etc/php${PHP_MAJOR_VERSION}/conf.d/blackfire.ini
EOF
