# druidfi/s3-sync

Container to sync backups to Amazon S3 and get them from there using s3cmd.

## Run sync

- Mount local path `/abs/path/to/backups` to container in `/data`
- Sync all files from local path to S3 bucket `foobar-bucket`

```
docker run -it -e ACCESS_KEY=foobar -e SECRET_KEY=foobar -e S3_PATH=s3://foobar-bucket \
    -v /abs/path/to/backups:/data druidfi/s3-sync sync
```

## Run in cron mode

```
docker run -it -e ACCESS_KEY=foobar -e SECRET_KEY=foobar -e S3_PATH=s3://foobar-bucket -e CRON_SCHEDULE="*/5 * * * *" \
    -v /abs/path/to/backups:/data druidfi/s3-sync
```

## s3cmd documentation

- See the documentation in https://s3tools.org/usage
- Sync specific documentation in https://s3tools.org/s3cmd-sync

## How to give access to S3 bucket

```
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::631176647059:user/USERNAME"
            },
            "Action": "S3:*",
            "Resource": "arn:aws:s3:::BUCKETNAME/*",
            "Condition": {}
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::631176647059:user/USERNAME"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::BUCKETNAME",
            "Condition": {}
        }
    ]
}
```