# Application
set :application, 'cydoc'
set :repository,  'git@github.com:huerlisi/CyDoc.git'

require 'capones_recipes/cookbook/rails'
require 'capones_recipes/tasks/restful_authentication'
require 'capones_recipes/tasks/carrier_wave'
require 'capones_recipes/tasks/sync'

# Staging
set :default_stage, "staging"

# Deployment
set :server, :passenger
set :user, "deployer"                               # The server's user for deploys

# Sync directories
set :sync_directories, ['uploads']
set :sync_backups, 3

# Configuration
set :scm, :git
ssh_options[:forward_agent] = true
set :use_sudo, false
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :copy_exclude, [".git", "spec", "test", "stories"]
