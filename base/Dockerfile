RUN <<EOF
#
# Add user to sudoers
#
echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/${DEFAULT_USER}
chmod 0440 /etc/sudoers.d/${DEFAULT_USER}
#
# Quiet down Sudo
#
echo "Set disable_coredump false" > /etc/sudo.conf
EOF
