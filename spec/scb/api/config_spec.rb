# encoding: utf-8

require_relative '../../spec_helper'

describe "Config" do
  subject {
    SCB::API::Config.new do |c|
      c.api_host    = api_host
      c.api_version = api_version
    end
  }

  let(:api_host)    { 'config.test' }
  let(:api_version) { 'v2'          }

  it "returns the api_host" do
    subject.api_host.must_equal api_host
  end

  it "returns the api_version" do
    subject.api_version.must_equal api_version
  end

  it "returns the base_url" do
    subject.base_url.must_equal 'http://config.test/OV0104/v2/sv/ssd'
  end

  describe "json_parser" do
    it "is a lambda by default" do
      subject.json_parser.
        parse('{"foo":123}')['foo'].must_equal 123
    end

    it "can be changed" do
      subject.json_parser = "foo"
      subject.json_parser.must_equal "foo"
    end
  end

  describe "http_client" do
    it "is Net::HTTP by default" do
      subject.http_client.must_equal SCB::HTTP
    end

    it "can be changed" do
      subject.http_client = "bar"
      subject.http_client.must_equal "bar"
    end
  end
end
