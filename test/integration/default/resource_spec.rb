# frozen_string_literal: true

control 'remote-file-s3-windows-1' do
  impact 1.0
  title 'Ensure file gets downloaded from S3 with proper permissions'

  domain = powershell('Write-Host $env:COMPUTERNAME').stdout.strip

  only_if { os.windows? }

  describe file('c:/remote_file_s3/new_file.txt') do
    it { should exist }
    its('size') { should be > 0 } # rubocop:disable Style/NumericPredicate
    it { should be_allowed('full-control', by_user: "#{domain}\\Administrator") }
    it { should be_allowed('full-control', by_user: "#{domain}\\vagrant") }
  end

  %w[
    existing_file_good_ownership.txt
    existing_file_bad_ownership.txt
  ].each do |f|
    describe file("c:/remote_file_s3/#{f}") do
      it { should exist }
      its('size') { should be > 0 } # rubocop:disable Style/NumericPredicate
      its('content') { should_not eq 'some test content here' }
      it { should be_allowed('full-control', by_user: "#{domain}\\Administrator") }
      it { should be_allowed('full-control', by_user: "#{domain}\\vagrant") }
    end
  end

  describe file('c:/remote_file_s3/file_no_owner.txt') do
    it { should exist }
    its('size') { should be > 0 } # rubocop:disable Style/NumericPredicate
    it { should be_allowed('full-control', by_user: "#{domain}\\vagrant") }
  end
end

control 'remote-file-s3-linux-1' do
  impact 1.0
  title 'Ensure file gets downloaded from S3 with proper permissions'

  only_if { os[:family] != 'windows' }

  describe file('/tmp/remote_file_s3/new_file.txt') do
    it { should exist }
    its('size') { should be > 0 } # rubocop:disable Style/NumericPredicate
    its('owner') { should eq 'root' }
    its('group') { should eq os.darwin? ? 'wheel' : 'root' }
    its('mode') { should eq 0o0644 }
  end

  %w[
    existing_file_good_ownership.txt
    existing_file_bad_ownership.txt
  ].each do |f|
    describe file("/tmp/remote_file_s3/#{f}") do
      it { should exist }
      its('size') { should be > 0 } # rubocop:disable Style/NumericPredicate
      its('content') { should_not eq 'some test content here' }
      its('owner') { should eq 'root' }
      its('group') { should eq os.darwin? ? 'wheel' : 'root' }
      its('mode') { should eq 0o0644 }
    end
  end

  describe file('/tmp/remote_file_s3/file_no_owner.txt') do
    it { should exist }
    its('size') { should be > 0 } # rubocop:disable Style/NumericPredicate
    its('content') { should_not eq 'some test content here' }
    its('owner') { should eq 'root' }
    its('group') { should eq os.darwin? ? 'staff' : 'root' }
    its('mode') { should eq 0o600 }
  end
end
