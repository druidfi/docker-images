ARG PHP_VERSION

FROM druidfi/drupal:${PHP_VERSION}-web AS baseline

ARG S2I_PATH=/usr/libexec/s2i

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="PHP + Nginx image for running Drupal 8 in OpenShift" \
      io.k8s.display-name="Drupal 8 OpenShift image" \
      io.openshift.tags="builder,php,nginx,alpine,drupal" \
      # this label tells s2i where to find its mandatory scripts
      # (run, assemble, save-artifacts)
      io.openshift.s2i.scripts-url="image://${S2I_PATH}"

# /app      Running folder for app
# /tmp/src/ This is where the source code will be cloned
# /code     This is where code is prepared
# /shared   Persistent volume claim should be mapped to this

RUN sudo mkdir -p /code /shared && \
    sudo fix-permissions /code && \
    sudo fix-permissions /shared && \
    sudo fix-permissions /etc/php7/conf.d && \
    sudo fix-permissions /var/run

# Copy configuration files and scripts
COPY files/ /

# Default command
CMD ["${S2I_PATH}/usage"]
