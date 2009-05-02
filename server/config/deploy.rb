set :application, 'uooneshow'
set :scm, :git
set :repository,  'git://github.com/also/oneshow.git'

set :deploy_to, '/var/www/uooneshow_com'

role :web, 'root@www3.ryanberdeen.com'
role :db,  'root@www3.ryanberdeen.com', :primary => true
set :use_sudo, true

namespace :deploy do
  task :start do

  end

  task :restart do
    run "touch #{latest_release}/tmp/restart.txt"
  end
end

after 'deploy:finalize_update' do
  run "chown -R www-data:www-data #{latest_release}"
end
