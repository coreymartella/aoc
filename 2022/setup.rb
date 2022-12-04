require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require_relative 'core_extensions'
require_relative 'aoc_api'
Bundler.require(:default)

Dotenv.require_keys('AOC_COOKIE')
