require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require_relative 'core_extensions'
Bundler.require(:default)

Dotenv.require_keys('AOC_COOKIE')
