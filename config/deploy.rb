# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "haba_na_haba_ussd_app"
set :repo_url, "https://github.com/Ayokunnumi1/Haba-na-haba-Ussd-App"

# Default branch is :master
set :branch, "feature/deployment"

set :assets_roles, [:web, :app]

set :keep_assets, 2
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "/home/deployhnh/#{fetch(:application)}"
# Default value for :format is :airbrussh.
# set :format, :airbrussh
set :bundle_jobs, 1
# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads", "storage"
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { 
  'RAILS_MASTER_KEY' => '0d10bd1926af890a647730b6d8238adf'
}
# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
namespace :deploy do
  desc "Install gems with reduced memory usage"
  task :install_gems do
    on roles(:app) do
      within release_path do
        execute :bundle, "install --jobs 1 --without development test"
      end
    end
  end
end

# Add these lines to install Node.js packages during deployment
namespace :deploy do
  desc 'Install npm packages'
  task :npm_install do
    on roles(:app) do
      within release_path do
        execute :npm, 'install'
      end
    end
  end
end

# Run npm install before asset precompilation
before 'deploy:assets:precompile', 'deploy:npm_install'

# Hook into deployment process
after "deploy:updated", "deploy:install_gems"

set :bundle_bins, fetch(:bundle_bins, []).push('rake', 'rails')
set :bundle_version, '2.6.3'  # Use a version that works with your app
set :default_env, { PATH: "$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH" }
