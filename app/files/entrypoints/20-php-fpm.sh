#!/bin/bash

echo "Start up PHP-FPM..."

php-fpm &

# Usage: php [-n] [-e] [-h] [-i] [-m] [-v] [-t] [-p <prefix>] [-g <pid>] [-c <file>] [-d foo[=bar]] [-y <file>] [-D] [-F [-O]]
#  -c <path>|<file> Look for php.ini file in this directory
#  -n               No php.ini file will be used
#  -d foo[=bar]     Define INI entry foo with value 'bar'
#  -e               Generate extended information for debugger/profiler
#  -h               This help
#  -i               PHP information
#  -m               Show compiled in modules
#  -v               Version number
#  -p, --prefix <dir>
#                   Specify alternative prefix path to FastCGI process manager (default: /usr).
#  -g, --pid <file>
#                   Specify the PID file location.
#  -y, --fpm-config <file>
#                   Specify alternative path to FastCGI process manager config file.
#  -t, --test       Test FPM configuration and exit
#  -D, --daemonize  force to run in background, and ignore daemonize option from config file
#  -F, --nodaemonize
#                   force to stay in foreground, and ignore daemonize option from config file
#  -O, --force-stderr
#                   force output to stderr in nodaemonize even if stderr is not a TTY
#  -R, --allow-to-run-as-root
#                   Allow pool to run as root (disabled by default)
