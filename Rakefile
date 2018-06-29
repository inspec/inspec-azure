# frozen_string_literal: true

require 'bundler'
require 'bundler/gem_helper'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'fileutils'
require 'open3'

require_relative 'libraries/support/azure/credentials'
require_relative 'lib/attribute_file_writer'

RuboCop::RakeTask.new

FIXTURE_DIR = "#{Dir.pwd}/test/fixtures"
TERRAFORM_DIR = 'terraform'

task default: :test
desc 'Testing tasks'
task test: ['test:unit', 'test:functional']

task 'test:functional': :setup_env

desc 'Set up Azure env, run functional tests, destroy Azure env'
task azure: 'azure:run'

namespace :azure do
  task run: ['tf:apply', 'test:functional', 'tf:destroy']

  desc 'Authenticate with the Azure CLI'
  task :login do
    sh(
      'az', 'login',
      '--service-principal',
      '-u', ENV['AZURE_CLIENT_ID'],
      '-p', ENV['AZURE_CLIENT_SECRET'],
      '--tenant', ENV['AZURE_TENANT_ID']
    )
  end
end

desc 'Linting tasks'
task lint: [:rubocop, :syntax, :'inspec:check']

desc 'Ruby syntax check'
task :syntax do
  files = %w{Gemfile Rakefile} + Dir['./**/*.rb']

  files.each do |file|
    sh('ruby', '-c', file) do |ok, res|
      next if ok

      puts 'Syntax check FAILED'
      exit res.exitstatus
    end
  end
end

task :check_attributes_file do
  abort('$ATTRIBUTES_FILE not set. Please source .envrc.') if ENV['ATTRIBUTES_FILE'].nil?
  abort('$ATTRIBUTES_FILE has no content. Check .envrc.') if ENV['ATTRIBUTES_FILE'].empty?
end

namespace :inspec do
  desc 'Runs profile against Azure with given Subscription Id'
  task :run, [:subscription_id] => :check_attributes_file do |_t, args|
    sh('./bin/inspec', 'exec', '.',
       '--attrs', "terraform/#{ENV['ATTRIBUTES_FILE']}",
       '-t', "azure://#{args[:subscription_id]}")
  end

  desc 'InSpec syntax check'
  task :check do
    stdout, status = Open3.capture2('./bin/inspec check .')

    puts stdout

    # TODO: add "warnings" back to list when we switch to using InSpec backend
    %w{errors}.each do |type|
      abort("InSpec check failed with syntax #{type}!") if !!(/[1-9]\d* #{type}/ =~ stdout)
    end

    status.exitstatus
  end
end

task :setup_env do
  credentials = Azure::Credentials.new
  ENV['TF_VAR_subscription_id'] = credentials.subscription_id
  ENV['TF_VAR_tenant_id']       = credentials.tenant_id
  ENV['TF_VAR_client_id']       = credentials.client_id
  ENV['TF_VAR_client_secret']   = credentials.client_secret
end

namespace :test do
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test/unit'
    t.libs << 'libraries'
    t.test_files = FileList['test/unit/**/*_test.rb']
  end

  task :functional, [:controls] => [:check_attributes_file] do |_t, args|
    credentials = Azure::Credentials.new

    cmd = %W( bin/inspec exec test/functional/verify
              --attrs terraform/#{ENV['ATTRIBUTES_FILE']}
              -t azure://#{credentials.subscription_id} )

    if args[:controls]
      sh(*cmd, '--controls', args[:controls], *args.extras)
    else
      sh(*cmd)
    end
  end
end

namespace :tf do
  workspace = ENV['WORKSPACE']

  task init: [:setup_env] do
    abort('$WORKSPACE not set. Please source .envrc.') if workspace.nil?
    abort('$WORKSPACE has no content. Check .envrc.') if workspace.empty?
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'init',
         '--backend-config', "storage_account_name=#{ENV['TF_STORAGE_ACCOUNT_NAME']}",
         '--backend-config', "access_key=#{ENV['TF_ACCESS_KEY']}",
         '--backend-config', "container_name=#{ENV['TF_CONTAINER_NAME']}")
    end
  end

  task workspace: [:init] do
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'workspace', 'select', workspace) do |ok, _|
        next if ok
        sh('terraform', 'workspace', 'new', workspace)
      end
    end
  end

  desc 'Creates a Terraform execution plan from the plan file'
  task plan: [:workspace] do
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'get')
      sh('terraform', 'plan', '-out', 'inspec-azure.plan')
    end
  end

  desc 'Executes the Terraform plan'
  task apply: [:workspace, :plan] do
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'apply', 'inspec-azure.plan')
    end

    Rake::Task['tf:attributes_file'].invoke(workspace)
  end

  desc 'Destroys the Terraform environment'
  task destroy: [:workspace] do
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'destroy', '-force')
    end
  end

  task attributes_file: [:workspace, :check_attributes_file] do
    Dir.chdir(TERRAFORM_DIR) do
      stdout, stderr, status = Open3.capture3('terraform output -json')

      abort(stderr) unless status.success?

      AttributeFileWriter.write_yaml(ENV['ATTRIBUTES_FILE'], stdout)
    end
  end
end
