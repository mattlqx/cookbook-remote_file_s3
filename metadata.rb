# frozen_string_literal: true

name 'remote_file_s3'
maintainer 'Matt Kulka'
maintainer_email 'matt@lqx.net'
license 'MIT'
description 'Provides remote_file_s3 resource'
long_description 'Provides remote_file_s3 resource that can idempotently download a file from an AWS S3 bucket'
version '1.0.5'

chef_version '>= 13' if respond_to?(:chef_version)
if respond_to?(:supports)
  supports 'debian'
  supports 'ubuntu'
  supports 'windows'
  supports 'centos'
  supports 'mac_os_x'
end

issues_url 'https://github.com/mattlqx/cookbook-remote_file_s3/issues' if respond_to?(:issues_url)
source_url 'https://github.com/mattlqx/cookbook-remote_file_s3' if respond_to?(:source_url)
