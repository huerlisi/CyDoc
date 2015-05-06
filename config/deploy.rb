# Application
set :application, 'cydoc'
set :repository,  'git@github.com:huerlisi/CyDoc.git'

require 'capones_recipes/cookbook/rails'
require 'capones_recipes/tasks/database/setup'
require 'capones_recipes/tasks/restful_authentication'
require 'capones_recipes/tasks/carrier_wave'
require 'capones_recipes/tasks/sync'
require 'capones_recipes/tasks/bluepill'

# Staging
set :default_stage, "staging"

# Deployment
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

# Dependencies
depend :remote, :gem, 'bundler', '> 0'

# Headers for gem compilation
depend :remote, :deb, "build-essential", ''
depend :remote, :deb, "ruby-dev", ''
depend :remote, :deb, "libcups2-dev", ''
depend :remote, :deb, "libsqlite3-dev", ''
depend :remote, :deb, "libmysqlclient-dev", ''
depend :remote, :deb, "libxml2-dev", ''
depend :remote, :deb, "libxslt1-dev", ''

# Import scripts
depend :remote, :deb, "build-essential", ''
depend :remote, :deb, "mdbtools", ''
depend :remote, :deb, "wget", ''
depend :remote, :deb, "sqlite3", ''
depend :remote, :deb, "unzip", ''
depend :remote, :deb, "recode", ''
