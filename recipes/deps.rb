# frozen_string_literal: true

#
# Cookbook:: remote_file_s3
# Recipe:: deps
#
# Copyright:: 2018, Matt Kulka

chef_gem 'aws-sdk-s3' do
  compile_time true
  version node['remote_file_s3']['aws-sdk-s3']['version']
end
