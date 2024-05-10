#!/bin/bash

function set_permissions {
  FILES_PATH=/app/${WEBROOT:-public}/sites/default/files/

  echo "- Delete css and js folder from public files"
  sudo rm -rf "${FILES_PATH}css" "${FILES_PATH}js"

  echo "- Set ownership of ${FILES_PATH} to www-data"
  sudo chown -R www-data:www-data "${FILES_PATH}"
}

set_permissions &
