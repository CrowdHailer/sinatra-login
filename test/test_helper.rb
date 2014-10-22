ENV['RACK_ENV'] = 'test'
ENV['RACK_SESSION_SECRET'] = 'dummy'

require 'minitest/autorun'

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'rack/test'
require_relative '../app'