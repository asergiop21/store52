# config valid only for Capistrano 3.1
lock '3.16.0'

set :application, 'store52'
set :user, 'deployer'
set :repo_url, 'git@github.com:asergiop21/store52.git'

set :format, :pretty
set :log_level, :debug

set :rbenv_type, :user
set :rbenv_ruby, '2.7.3'
set :branch, 'master'

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/packs", "node_modules"
set :keep_releases, 5

namespace :deploy do

end
