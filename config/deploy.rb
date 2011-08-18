require 'recipes/rails'
require 'recipes/restful_authentication'
require 'recipes/database/sync'

set :application, "cydoc"
set :repository,  "git@github.com:huerlisi/CyDoc.git"

# Staging
set :stages, %w(demo)
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
# Try loading a deploy_provider.rb
begin
  load File.expand_path('../deploy_provider.rb', __FILE__)
rescue LoadError
end

# Plugins
# =======
# Multistaging
require 'capistrano/ext/multistage'
