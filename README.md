# remote_file_s3

This resource simply downloads a file from S3 given a bucket and path. Despite its name, it does not use the `remote_file` resource behind the scenes for idempotence or to transfer the file and instead implements an internal catalog to track files' sha256 sums and etags at time of download for idempotence and the `aws-sdk-s3` gem for file transfer.

### Why do we need yet another s3 file resource?

Well, IMO, they're all poorly implemented either by way of being too complex (trying to implement everything themselves), by using cli tool shellouts, or by incorrectly making assumptions about Amazon's etags. This resource places no importance on the way Amazon generates their etags (which is inconsistent depending on file attributes) and simply uses it as HTTP intends you to, as an indicator that a file has changed by a simple equality check.

### Platforms

- Ubuntu
- Centos
- RHEL
- Debian
- Red Hat
- macOS
- Windows

## Usage

Just `depends` on this cookbook to be able to use this resource in your cookbook/recipes.

## `remote_file_s3`

### Example

```ruby
remote_file_s3 '/tmp/foo.txt' do
  bucket 'mybucket'
  remote_path 'myfolder/foo.txt'
  aws_access_key_id 'myaccesskey'
  aws_secret_access_key 'mysecretkey'
  action :create
end
```

### Properties

- `bucket` - The name of the S3 bucket in which the file resides.
- `remote_path` - Path to the file inside the bucket.
- `aws_acccess_key_id` - Explicitly use this access key, overriding any instance profile.
- `aws_secret_access_key` - Explicitly use this access key, overriding any instance profile.
- `aws_session_token` - Token required when using an access key for a role.
- `owner` - Username or UID that the file will be owned by.
- `group` - Group name or GID that the file will be owned by.
- `mode` - Access mode for the file.
- `rights` and `deny_rights` - Passed through to `file` resource to apply Windows permissions.
- `inherits` - Passed through to `file` resource to specify Windows permissions inheritance.
- `region` - AWS region to use for the endpoint. Defaults to EC2 instance region or `us-west-2` if not an EC2 instance.

## Recipes

The `aws-sdk-s3` gem is installed via the `deps` recipe but you do not need to run this explicitly. It will automatically be loaded when the `remote_file_s3` resource is used if `aws-sdk-s3` does not exist.

## License and Authors

Authors: Matt Kulka <matt@lqx.net>
