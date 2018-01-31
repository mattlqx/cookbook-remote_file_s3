# frozen_string_literal: true

#
# Cookbook:: remote_file_s3
# Recipe:: deps
#
# Copyright:: 2018, Matt Kulka

chef_gem 'aws-sdk-s3' do
  compile_time true
end
