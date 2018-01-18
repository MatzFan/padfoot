#!/usr/bin/env ruby
# frozen_string_literal: true

#
# This file was generated by Bundler.
#
# The application 'aws-v3.rb' is installed as part of a gem, and
# this file is here to facilitate running it.
#

bundle_binstub = File.expand_path("../bundle", __FILE__)
load(bundle_binstub) if File.file?(bundle_binstub)

require "pathname"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile",
  Pathname.new(__FILE__).realpath)

require "rubygems"
require "bundler/setup"

load Gem.bin_path("aws-sdk-resources", "aws-v3.rb")
