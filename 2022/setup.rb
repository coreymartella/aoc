require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require_relative 'core_extensions'
Bundler.require(:default)
require_relative 'aoc_api'

Dotenv.require_keys('AOC_COOKIE')
