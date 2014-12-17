require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:sequel)
PadrinoTasks.init

task :update_app_refs do
  ruby 'db/maintain/update_app_refs.rb'
end
