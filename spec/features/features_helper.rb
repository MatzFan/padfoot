require 'capybara/rspec'
require 'capybara/email/rspec'
require 'selenium-webdriver'

def start_remote_selenium_server
  creds = '--username IEUser --password Passw0rd!'
  vm = 'IE9 - Win7'
  bat_path = 'C:\Users\IEUser\Downloads\selenium.bat'
  cmd = 'c:\windows\system32\cmd.exe' # windows CLI
  arg = '/c start /d c:\Users\IEUser\Downloads selenium.bat' # /d runs process detached :)
  %x[VBoxManage guestcontrol '#{vm}' exec --image '#{cmd}' #{creds} -- '#{arg}']
  sleep 1
end

Capybara.app = Padfoot::App # need this to tell Capy what the app is..

Padfoot::App.set :delivery_method, :test # for capybara-email
Capybara.server_port = Padrino::Application.settings.port # so email links work in capy-email

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome) # register chrome
end

Capybara.default_driver = :selenium_chrome # uses FF by default
Capybara.javascript_driver = :selenium_chrome # uses selenium FF by default

if ENV["SELENIUM"] == 'remote'
  start_remote_selenium_server
  url = 'http://127.0.0.1:4444/wd/hub'
  caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
  caps['javascriptEnabled'] = true
  Capybara.register_driver :remote_browser do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: url,
      desired_capabilities: caps)
  end
  ip = '10.0.2.2' # default gateway..
  Capybara.app_host = "http://#{ip}:#{Capybara.server_port}"
  Capybara.default_driver = :remote_browser
  Capybara.javascript_driver = :remote_browser
end
