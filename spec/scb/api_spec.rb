# encoding: utf-8

require_relative '../spec_helper'

describe "API" do
  subject { SCB::API }

  let(:api)           { api_with_test_config(SCB::API.new) }
  let(:base_url)      { "http://api.test/name/v0/lang/db" }
  let(:expected_uri)  { URI.parse "#{base_url}/endpoint" }

  let(:fake_http_post) {
    # With UTF8 BOM, since the real API has this bug.
    ->(path, json){ fake_response("\xEF\xBB\xBF#{json}") }
  }

  describe "initialize" do
    it "takes a config" do
      subject.new("foo").config.must_equal "foo"
    end

    it "instantiates a default config" do
      subject.new.config.api_host.must_equal "api.scb.se"
    end
  end

  describe "get" do
    it "checks for nil responses" do
      api.stub(:http_get, nil) do
        api.get('nil').must_be_nil
      end
    end

    it "retrieves the data using a HTTP GET" do
      api.stub(:http_get, fake_response('foo')) do
        api.get.must_equal "foo"
      end
    end
  end

  describe "get_and_parse" do
    it "parses the returned body" do
      api.stub(:http_get, fixture_response('sv/ssd/BO')) do
        api.get_and_parse.last["id"].must_equal "BO0701"
      end
    end
  end

  describe "post" do
    it "unfortunately receives the body with an UTF8 BOM" do
      api.stub(:http_post, fake_http_post) do
        api.post(nil, { foo: "bar"}).
          must_equal "\xEF\xBB\xBF{\"foo\":\"bar\"}"
      end
    end

    it "strips the UTF8 BOM if the format is json" do
      api.stub(:http_post, fake_http_post) do
        query = { foo: "bar", response: { format: "json" } }

        api.post(nil, query).
          must_equal '{"foo":"bar","response":{"format":"json"}}'
      end
    end
  end

  describe "post_and_parse" do
    it "forces the format to be JSON" do
      api.stub(:http_post, fake_http_post) do
        query = { response: { format: "png" } }
        api.post_and_parse(nil, query).must_equal({
          "response" => { "format" => "json" }
        })
      end
    end
  end

  describe "base_url" do
    it "returns the base URL" do
      api.base_url.must_equal base_url
    end
  end

  describe "uri" do
    it "it returns a URI pointing to the provided endpoint" do
      api.uri("endpoint").must_equal expected_uri
    end
  end

  describe "load_json" do
    it "can load JSON" do
      api.load_json('{"baz":[1,2,3]}')['baz'].first.must_equal 1
    end
  end

  describe "dump_json" do
    it "can dump JSON" do
      api.dump_json({ foo: 123}).must_equal '{"foo":123}'
    end
  end
end
