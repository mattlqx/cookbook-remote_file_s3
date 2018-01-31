## Testing

### Test Kitchen

Create a `.s3.yml` file that contains the following keys:

```
---
access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
region: us-west-2
bucket: mybucket
file: test/test.txt
```

The test recipe used to converge in Kitchen will instantiate a `remote_file_s3` resource using these values. If you use the `ENV` values above for the access keys, ensure they are set in your environment when you execute Kitchen. If you wish to use kitchen-ec2 to create test instances and you wish to use its instance profile, you can leave `access_key_id` and `secret_access_key` as `nil` but they must be set.

### RSpec

Rspec/ChefSpec unit tests can be run by simply running `rspec`.
