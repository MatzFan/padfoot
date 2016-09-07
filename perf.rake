require 'bundler'
Bundler.setup

require 'derailed_benchmarks'
require 'derailed_benchmarks/tasks'

# subclass of AuthHelper requires a :call method
class PadfootAuth < DerailedBenchmarks::AuthHelper
  def setup
    require_relative 'app/helpers/sessions_helper'
    extend ::SessionsHelper # makes :sign_in method available
  end

  def session
    { 'rack.session' => { current_user: User.first.id } }
  end

  def call(env)
    sign_in User.first
    raise 'not signed in' unless signed_in?
    app.call(env)
  end
end

namespace :perf do
  desc 'loads the app for derailed_benchmarks'
  task :rack_load do
    require_relative 'config/boot'
    DERAILED_APP = Padfoot::App
    ENV['RACK_ENV'] = 'production'
    ENV['USE_SERVER'] = 'thin'
    ENV['USE_AUTH'] = 'true'
    cmd = 'heroku config -r production|grep DATABASE_URL'
    ENV['DATABASE_URL'] = `#{cmd}`.chomp.split(' ').last
    DerailedBenchmarks.auth = PadfootAuth.new
  end
end
