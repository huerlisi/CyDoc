# -*- encoding : utf-8 -*-
# Application

# Deployment
set :domain, 'demo.cyt.ch'

set :rails_env, 'demo'
set :branch, "master"

set :deploy_to, "/srv/#{domain}/#{application}"
role :web, "#{application}.#{stage}"                          # Your HTTP server, Apache/etc
role :app, "#{application}.#{stage}"                          # This may be the same as your `Web` server
role :db,  "#{application}.#{stage}", :primary => true        # This is where Rails migrations will run
