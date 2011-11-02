require 'recipes/rails'
require 'recipes/restful_authentication'
require 'recipes/database/sync'

# Application
set :application, 'cydoc'
set :repository,  'git@github.com:huerlisi/CyDoc.git'

# Staging
set :default_stage, "staging"

# Deployment
set :server, :passenger
set :user, "deployer"                               # The server's user for deploys

# Configuration
set :scm, :git
ssh_options[:forward_agent] = true
set :use_sudo, false
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :copy_exclude, [".git", "spec", "test", "stories"]

# Provider
# ========
# Load configuration
config_path = File.expand_path('~/.capones.yml')

if File.exist?(config_path)
  # Parse config file
  config = YAML.load_file(config_path)

  # States
  deploy_target_path = File.expand_path(config['deploy_target_repository']['path'])

  # Add stages
  set :stage_dir, File.join(deploy_target_path, application, 'stages')
  load_paths << ""
end

# Plugins
# =======
# Multistaging
require 'capistrano/ext/multistage'
