# Example setup for Drupal using separate services

Download the latest Drupal to public folder:

```shell
mkdir public
cd public
curl -sSL https://www.drupal.org/download-latest/tar.gz | tar -xz --strip-components=1
cd ..
```

Start up the services:

```shell
docker compose up -d
```

See example Drupal in https://example-drupal.docker.so/
