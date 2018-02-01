# frozen_string_literal: true

dir_path = case node['os']
           when 'windows'
             'c:/remote_file_s3'
           else
             '/tmp/remote_file_s3'
           end

directory dir_path do
  if node['os'] == 'windows'
    rights :full_control, 'Administrators'
    inherits false
  end
end

group 'otheruser' do
  not_if { node['os'] == 'windows' }
end

user 'otheruser' do
  group 'otheruser'
end

file "make #{dir_path}/existing_file_good_ownership.txt" do
  path "#{dir_path}/existing_file_good_ownership.txt"
  owner node['test_owner'] unless node['test_owner'].nil?
  group node['test_group'] unless node['test_group'].nil?
  mode node['test_mode'] unless node['test_mode'].nil?
  rights :full_control, node['test_owner'] unless node['test_owner'].nil? || node['os'] != 'windows'
  content 'some test content here'
end

file "make #{dir_path}/existing_file_bad_ownership.txt" do
  path "#{dir_path}/existing_file_bad_ownership.txt"
  owner 'otheruser'
  group 'otheruser'
  mode node['test_mode'] unless node['test_mode'].nil?
  rights :full_control, 'otheruser' if node['os'] == 'windows'
  content 'some test content here'
end

%w[
  new_file.txt
  existing_file_good_ownership.txt
  existing_file_bad_ownership.txt
].each do |f|
  remote_file_s3 "#{dir_path}/#{f}" do
    owner node['test_owner'] unless node['test_owner'].nil?
    group node['test_group'] unless node['test_group'].nil?
    mode node['test_mode'] unless node['test_mode'].nil?
    rights :full_control, node['test_owner'] unless node['test_owner'].nil?
    aws_access_key_id node['remote_file_s3_test']['aws_access_key_id']
    aws_secret_access_key node['remote_file_s3_test']['aws_secret_access_key']
    bucket node['remote_file_s3_test']['bucket']
    remote_path node['remote_file_s3_test']['file']
    region node['remote_file_s3_test']['region']
  end
end

remote_file_s3 "#{dir_path}/file_no_owner.txt" do
  aws_access_key_id node['remote_file_s3_test']['aws_access_key_id']
  aws_secret_access_key node['remote_file_s3_test']['aws_secret_access_key']
  bucket node['remote_file_s3_test']['bucket']
  remote_path node['remote_file_s3_test']['file']
  region node['remote_file_s3_test']['region']
end
