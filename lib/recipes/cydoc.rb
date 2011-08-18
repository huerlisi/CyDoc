before "deploy:setup", "cydoc:setup"
after "deploy:update_code", "cydoc:symlink"

namespace :cydoc do
  desc "Create vesr directory in capistrano shared path"
  task :setup do
    run "mkdir -p #{shared_path}/data/vesr"
    run "mkdir -p #{shared_path}/public/esr_files"
  end

  desc "Make symlink for shared vesr directory"
  task :symlink do
    run "ln -nfs #{shared_path}/data/vesr/ #{release_path}/data/vesr"
    run "ln -nfs #{shared_path}/data/esr_files #{release_path}/public/esr_files"
  end
end
