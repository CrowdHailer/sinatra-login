ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'rack/test'
require_relative '../app'