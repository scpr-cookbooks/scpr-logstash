require 'spec_helper'

describe 'scpr-logstash::default' do
  # Logstash is installed
  describe file("/opt/logstash/scpr/bin/logstash") do
    it { should exist }
    it { should be_executable }
  end

  # The logstash_scpr service is running
  describe service("logstash_scpr") do
    it { should be_running }
  end

  # The Logstash config is valid
  describe command("/opt/logstash/scpr/bin/logstash -f /opt/logstash/scpr/etc/conf.d/ -t") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should contain "Configuration OK" }
  end
end

describe 'scpr-logstash::kibana' do
  # nginx is running
  describe process('nginx') do
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  # kibana is running

  # kibana runs via a node process that's kind of annoying to single out
  #describe process('kibana') do
  #  it { should be_running }
  #end

  # kibana is listening

  describe port(5061) do
    it { should be_listening }
  end
end
