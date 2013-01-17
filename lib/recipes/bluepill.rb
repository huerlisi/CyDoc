# -*- encoding : utf-8 -*-
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} start"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} restart"
  end
end

after "deploy:setup", "bluepill:configure"

namespace :bluepill do
  desc "Create bluepill recipe"
  task :configure, :roles => [:app], :except => { :no_release => true } do
    #{shared_path}
    location = fetch(:template_dir, "config/deploy") + '/bluepill.rb.erb'
    template = File.read(location)
    config = ERB.new(template)

    put config.result(binding), "#{shared_path}/config/bluepill.rb"
  end

  desc "Load bluepill recipe"
  task :load, :roles => [:app], :except => { :no_release => true } do
    run "bluepill --no-privileged load #{shared_path}/config/bluepill.rb"
  end

  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    set :bluepill_app, "#{client}.#{domain}"
    run "bluepill --no-privileged #{bluepill_app} status"
  end
end
