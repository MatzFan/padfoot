require 'bundler'
Bundler.setup

require 'derailed_benchmarks'
require 'derailed_benchmarks/tasks'

namespace :perf do
  task :rack_load do
    require_relative '../config/boot'
    DERAILED_APP = Padfoot::App
  end
end
