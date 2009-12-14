require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Inploy::Deploy do

  def expect_setup_with(branch, environment = 'production')
    if branch.eql? 'master'
      checkout = ""
    else
      checkout = "&& $($(git branch | grep -vq #{branch}) && git checkout -f -b #{branch} origin/#{branch})"
    end
    expect_command "ssh #{@ssh_opts} #{@user}@#{@host} 'cd #{@path} && git clone --depth 1 #{@repository} #{@application} && cd #{@application} #{checkout} && rake inploy:local:setup environment=#{environment}'"
  end

  def setup(subject)
    mute subject
    stub_commands
    subject.template = :sinatra
    subject.user = @user = 'batman'
    subject.hosts = [@host = 'gothic']
    subject.path = @path = '/city'
    subject.repository = @repository = 'git://'
    subject.application = @application = "robin"
  end

  it "should use master as default branch" do
    setup subject
    expect_setup_with "master"
    subject.remote_setup
  end
  
  it "should use production as default environment" do
    setup subject
    expect_command "gem bundle"
    dont_accept_command "rake db:migrate RAILS_ENV=production"
    subject.local_setup
  end

  it "should use production as the default environment" do
    subject.environment.should eql("production")
  end

  context "configured" do
    before :each do
      setup subject
			subject.ssh_opts = @ssh_opts = "-A"
			subject.branch = @branch = "onions"
			subject.environment = @environment = "staging"
    end

    context "on remote setup" do
      it "should clone the repository with the application name, checkout the branch and execute local setup" do
        expect_setup_with @branch, @environment
        subject.remote_setup
      end

      it "should not execute init.sh if doesnt exists" do
        dont_accept_command "ssh #{@user}@#{@host} 'cd #{@path}/#{@application} && .init.sh'"
        subject.remote_setup
      end
    end

    context "on local setup" do
      it "should use staging for the environment" do
        subject.environment.should eql("staging")
        subject.local_setup
      end
    end

    context "on remote update" do
      it_should_behave_like "remote update"
    end

    context "on local update" do
      it "should pull the repository" do
        expect_command "git pull origin #{@branch}"
        subject.local_update
      end

      it "should bundle gems" do
        expect_command "gem bundle"
        subject.local_update
      end
    end
  end
end
