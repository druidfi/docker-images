#!/usr/bin/env bash

# Update in some automation:
# sed -i '' "s/VERSION=.*/VERSION=1.2.3/g" update.sh
VERSION=1.0.0
GITHUB=https://raw.githubusercontent.com
REPOSITORY=dunglas/symfony-docker
BRANCH=main
REPOSITORY_URL=https://github.com/${REPOSITORY}

while true; do
  case "$1" in
    -b | --branch ) BRANCH="$2"; shift ;;
    * ) break ;;
  esac
done

RED="[0;31m"
GREEN="[0;32m"
YELLOW="[0;33m"
NORMAL="[0m"

declare -a files=(
  ".dockerignore"
  "Dockerfile"
  "frankenphp/docker-entrypoint.sh"
  "frankenphp/Caddyfile"
  "frankenphp/conf.d/10-app.ini"
  "frankenphp/conf.d/20-app.dev.ini"
  "frankenphp/conf.d/20-app.prod.ini"
)

declare -a targets=(
  "frankenphp/.dockerignore"
  "frankenphp/Dockerfile.dist"
  "frankenphp/docker-entrypoint.dist.sh"
  "frankenphp/conf/caddy/Caddyfile"
  "frankenphp/conf/php/10-app.ini"
  "frankenphp/conf/php/20-app.dev.ini"
  "frankenphp/conf/php/20-app.prod.ini"
)

main() {

  printf "\n\e%s%s updater (version %s)\e%s\n\n" "${YELLOW}" "${REPOSITORY}" "${VERSION}" "${NORMAL}"

  info "Download following files from ${REPOSITORY_URL}:"
  printf "\n"
  printf '%s\n' "${files[@]}"

  for i in "${!files[@]}"
  do
     file=${files[i]}
     timestamp=$(date +%s)
     urls[${i}]="${GITHUB}/${REPOSITORY}/${BRANCH}/${file}?t=${timestamp}"
  done

  for i in "${!files[@]}"
  do
    curl -LJs -o "${targets[i]}" "${urls[i]}"
  done

  if [[ $? -eq 0 ]]
  then
    printf "\n\e%s[OK]\e%s Update complete!\e%s\n" "${GREEN}" "${YELLOW}" "${NORMAL}"
    printf "\n"
    info "Use git diff or your IDE diff tools to see the changes"
    exit 0
  else
    printf "\n\e%s[ERROR]\e%s Check if update.sh has correct settings\n" "${RED}" "${NORMAL}"
    exit 1
  fi
}

info() {
  printf "\e%s[Info]\e%s %s\n" "${YELLOW}" "${NORMAL}" "${1}"
}

main
