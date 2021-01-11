# Example setup for Drupal using separate services

Download latest Drupal to public folder:

```
$ (cd public && curl -sSL https://www.drupal.org/download-latest/tar.gz | tar -xz --strip-components=1)
```

Start up the services:

```
$ docker-compose up -d
```
