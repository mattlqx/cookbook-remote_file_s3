# frozen_string_literal: true

#
# Cookbook:: remote_file_s3
# Spec:: deps
#
# Copyright:: 2018, Matt Kulka

require 'spec_helper'

describe 'remote_file_s3::deps' do
  %w(ubuntu/20.04 centos/7.4.1708 windows/2019 mac_os_x/10.15).each do |p|
    platform(*p.split('/'))

    context "When all attributes are default, on #{p}" do
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'installs gems' do
        expect(chef_run).to install_chef_gem('aws-sdk-s3')
      end
    end
  end
end
