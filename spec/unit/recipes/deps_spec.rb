# frozen_string_literal: true

#
# Cookbook:: remote_file_s3
# Spec:: deps
#
# Copyright:: 2018, Matt Kulka

require 'spec_helper'

describe 'remote_file_s3::deps' do
  %w[ubuntu/16.04 centos/7.4.1708 windows/2012R2 mac_os_x/10.13].each do |platform|
    context "When all attributes are default, on #{platform}" do
      let(:chef_run) do
        # for a complete list of available platforms and versions see:
        # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
        runner = ChefSpec::ServerRunner.new(platform: platform.split('/')[0], version: platform.split('/')[1])
        runner.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'installs gems' do
        expect(chef_run).to install_chef_gem('aws-sdk-s3')
      end
    end
  end
end
