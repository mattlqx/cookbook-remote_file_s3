# frozen_string_literal: true

#
# Cookbook:: remote_file_s3
# Spec:: resource
#
# Copyright:: 2018, Matt Kulka

require 'spec_helper'

describe 'remote_file_s3_test::default' do
  %w[ubuntu/16.04 centos/7.4.1708 windows/2012R2 mac_os_x/10.13].each do |platform|
    context "when on #{platform}" do
      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new(platform: platform.split('/')[0], version: platform.split('/')[1])
        runner.node.default['remote_file_s3_test'] = {
          bucket: 'foo',
          file: 'bar',
          region: 'us-west-2',
          aws_access_key_id: 'testkeyid',
          aws_secret_access_key: 'testkey'
        }
        runner
      end

      before do
        chef_run.converge(described_recipe)
      end

      let(:dir_path) { chef_run.node['platform'] == 'windows' ? 'c:/remote_file_s3' : '/tmp/remote_file_s3' }

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'creates directories to download file' do
        expect(chef_run).to create_directory(dir_path)
      end

      it 'creates test user' do
        expect(chef_run).to create_user('otheruser')
      end

      it 'creates test group' do
        expect(chef_run).to create_group('otheruser') unless chef_run.node['platform'] == 'windows'
      end

      it 'creates files to overwrite' do
        expect(chef_run).to create_file("make #{dir_path}/existing_file_bad_ownership.txt")
      end

      it 'creates new s3 file' do
        expect(chef_run).to create_remote_file_s3("#{dir_path}/new_file.txt")
        expect(chef_run).to create_remote_file_s3("#{dir_path}/file_no_owner.txt")
      end

      it 'creates file to be overwritten' do
        expect(chef_run).to create_file("#{dir_path}/existing_file_good_ownership.txt")
      end

      it 'should overwrite existing file with new s3 file' do
        expect(chef_run).to create_remote_file_s3("#{dir_path}/existing_file_good_ownership.txt")
        expect(chef_run).to create_remote_file_s3("#{dir_path}/existing_file_bad_ownership.txt")
      end
    end
  end
end
