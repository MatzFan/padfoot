require 'bundler'
Bundler.setup

require 'derailed_benchmarks'
require 'derailed_benchmarks/tasks'

namespace :perf do
  desc 'loads the app for derailed_benchmarks'
  task rack_load: :environment do
    require_relative '../config/boot'
    DERAILED_APP = Padfoot::App
  end
end
