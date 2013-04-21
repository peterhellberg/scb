# encoding: utf-8

require "minitest/spec"
require "minitest/pride"
require "minitest/autorun"

require_relative "../lib/scb"

$loaded_fixtures = {}
$parsed_fixtures = {}

def s(*args)
  subject.new(*args)
end

def fixture(name)
  $loaded_fixtures[name] ||= IO.read("spec/fixtures/#{name}.json")
end

def parsed_fixture(name)
  $parsed_fixtures[name] ||= JSON.parse(fixture(name))
end

def api_with_test_config(api)
  test_configuration!(api.config)

  api
end

def test_configuration!(c)
  c.api_host    = 'api.test'
  c.api_name    = 'name'
  c.api_version = 'v0'
  c.language    = 'lang'
  c.database    = 'db'
end

class SCB::HTTP::FakeResponse
  attr_reader :body

  def initialize(body = nil)
    @body = body
  end
end

def fake_response(body)
  SCB::HTTP::FakeResponse.new(body)
end

def fixture_response(name)
  fake_response(fixture(name))
end
