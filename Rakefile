require 'bundler'
require 'bundler/gem_helper'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'fileutils'
require 'open3'
require 'chefstyle'

require_relative 'lib/attribute_file_writer'
require_relative 'lib/environment_file'

RuboCop::RakeTask.new

FIXTURE_DIR   = "#{Dir.pwd}/test/fixtures".freeze
TERRAFORM_DIR = 'terraform'.freeze
REQUIRED_ENVS = %w{AZURE_CLIENT_ID AZURE_CLIENT_SECRET AZURE_TENANT_ID AZURE_SUBSCRIPTION_ID}.freeze
INTEGRATION_DIR = 'test/integration/verify'.freeze
TF_PLAN_FILE_NAME = 'inspec-azure.plan'.freeze
TF_PLAN_FILE = File.join(TERRAFORM_DIR, TF_PLAN_FILE_NAME)
ATTRIBUTES_FILE_NAME = ''.freeze

task default: :test
desc 'Testing tasks'
task test: %w{lint test:unit}

desc 'Linting tasks'
# task lint: [:rubocop, :'syntax:ruby', :'syntax:inspec']

desc 'Run rubocop chefstyle linter + unit tests'
task default: [:lint, :test]

# lint the project
# chefstyle
begin
  RuboCop::RakeTask.new(:lint) do |task|
    task.options += ['--display-cop-names', '--no-color', '--parallel']
  end
rescue LoadError
  puts 'rubocop is not available. Install the rubocop gem to run the lint tests.'
end

task :setup_env do
  puts '-> Loading Environment Variables'
  ENV['TF_VAR_subscription_id'] = ENV['AZURE_SUBSCRIPTION_ID']
  ENV['TF_VAR_tenant_id']       = ENV['AZURE_TENANT_ID']
  ENV['TF_VAR_client_id']       = ENV['AZURE_CLIENT_ID']
  ENV['TF_VAR_client_secret']   = ENV['AZURE_CLIENT_SECRET']

  puts '-> Ensuring required Environment Variables are set'
  missing = REQUIRED_ENVS.reject { |var| ENV.key?(var) }
  abort("ENV missing: #{missing.join(', ')}") if missing.any?

  # Notify user which optional components they are using
  options = EnvironmentFile.options('.envrc')
  if options.empty?
    puts "-> You are not using any optional components. See the README for more information.\n\n"
  else
    puts "-> You are using the following optional components:\n\n"
    options.each do |option|
      puts "* #{option}\n"
    end
    puts "\nTo change these options run: rake options[component] or add desired components to your .envrc file. See the README for more information.\n\n"
  end
end

namespace :syntax do
  desc 'InSpec syntax check'
  task :inspec do
    puts '-> Checking InSpec Control Syntax'
    stdout, status = Open3.capture2("bundle exec inspec vendor #{INTEGRATION_DIR} --overwrite --chef-license accept-silent &&
                                     bundle exec inspec check #{INTEGRATION_DIR}")
    puts stdout

    %w{errors}.each do |type|
      sh("rm -rf #{INTEGRATION_DIR}/vendor")
      abort("InSpec check failed with syntax #{type}!") if !!(/[1-9]\d* #{type}/ =~ stdout)
    end
    status.exitstatus
  end

  desc 'Ruby syntax check'
  task :ruby do
    puts '-> Checking Ruby Syntax'
    files = %w{Gemfile Rakefile} + Dir['./lib*/**/*.rb'] + Dir['./test/**/*.rb']

    files.each do |file|
      sh('ruby', '-c', file) do |ok, res|
        next if ok
        puts 'Syntax check FAILED'
        exit res.exitstatus
      end
    end
  end
end

namespace :azure do
  desc 'Authenticate with the Azure CLI'
  task login: [:setup_env] do
    puts '-> Logging into Azure'
    sh(
      'az', 'login',
      '--service-principal',
      '-u', ENV['AZURE_CLIENT_ID'],
      '-p', ENV['AZURE_CLIENT_SECRET'],
      '--tenant', ENV['AZURE_TENANT_ID']
    )
    puts '-> Setting Subscription'
    sh(
      'az', 'account', 'set',
      '-s', ENV['AZURE_SUBSCRIPTION_ID']
    )
  end
end

namespace :test do
  # set env
  ENV['RAKE_ENV'] = 'test'
  # Minitest
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test/unit'
    t.libs << 'libraries'
    t.verbose = true
    t.warning = false
    t.test_files = FileList['test/unit/**/*_test.rb']
  end

  task :integration, [:controls] => ['tf:write_tf_output_to_file', :setup_env] do |_t, args|
    cmd = %W( bundle exec inspec exec #{INTEGRATION_DIR}
              --input-file terraform/#{ENV['ATTRIBUTES_FILE']}
              --reporter cli
              --no-distinct-exit
              -t azure://#{ENV['AZURE_SUBSCRIPTION_ID']}
              --chef-license accept-silent )

    if args[:controls]
      sh(*cmd, '--controls', args[:controls], *args.extras)
    else
      sh(*cmd)
    end
  end
end

namespace :tf do    # rubocop:disable Metrics/BlockLength
  workspace = ENV['WORKSPACE']

  task init: [:'azure:login'] do
    abort('$WORKSPACE not set. Please source .envrc.') if workspace.nil?
    abort('$WORKSPACE has no content. Check .envrc.') if workspace.empty?
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'init')
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
  task :plan, [:optionals] => [:workspace] do |_t, args|
    if args[:optionals]
      ignore_list = Array(args[:optionals]) + args.extras
      ignore_list.each do |component|
        ENV["TF_VAR_#{component}_count"] = '0'
      end
    end
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'get')
      sh('terraform', 'plan', '-out', 'inspec-azure.plan')
    end

    Rake::Task['tf:write_tf_output_to_file'].invoke
  end

  desc 'Executes the Terraform plan'
  task :apply, [:optionals] do |_t, args|
    if File.exist?(TF_PLAN_FILE)
      puts "-> Applying an existing terraform plan: #{TF_PLAN_FILE}"
      unless args[:optionals].nil?
        puts "These arguments are ignored: #{Array(args[:optionals]) + args.extras}."
      end
    else
      Rake::Task['tf:plan'].invoke(args[:optionals])
    end
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'apply', 'inspec-azure.plan')
    end
  end

  desc 'Destroys the Terraform environment'
  task destroy: [:workspace] do
    Dir.chdir(TERRAFORM_DIR) do
      sh('terraform', 'destroy', '-force')
    end
  end

  task write_tf_output_to_file: [:workspace] do
    Dir.chdir(TERRAFORM_DIR) do
      stdout, stderr, status = Open3.capture3('terraform output -json')

      abort(stderr) unless status.success?
      abort('$ATTRIBUTES_FILE not set. Please source .envrc.') if ENV['ATTRIBUTES_FILE'].nil?
      abort('$ATTRIBUTES_FILE has no content. Check .envrc.') if ENV['ATTRIBUTES_FILE'].empty?

      AttributeFileWriter.write_yaml(ENV['ATTRIBUTES_FILE'], stdout)
    end
  end
end

namespace :docs do
  desc 'Prints markdown links for resource doc files to update the README'
  task :resource_links do
    puts "\n"
    Dir.entries('docs/resources').sort
       .reject { |file| File.directory?(file) }
       .collect { |file| "- [#{file.split('.')[0]}](docs/resources/#{file})" }
       .map { |link| puts link }
    puts "\n"
  end
end

namespace :attributes do
  desc 'Create attributes used for integration testing'
  task :write do
    abort('$ATTRIBUTES_FILE not set. Please source .envrc.') if ENV['ATTRIBUTES_FILE'].nil?
    abort('$ATTRIBUTES_FILE has no content. Check .envrc.') if ENV['ATTRIBUTES_FILE'].empty?
    Rake::Task['tf:write_tf_output_to_file'].invoke
  end
end
