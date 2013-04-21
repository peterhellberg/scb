# encoding: utf-8

require_relative '../spec_helper'

describe SCB::DB do
  subject { SCB::DB }

  let(:db)    { subject.new(api) }
  let(:api)   { api_with_test_config(SCB::API.new) }
  let(:data)  { parsed_fixture('sv/ssd') }
  let(:table) { db.table('baz') }
  let(:level) { db.level('foo', 'bar') }

  let(:expected_uri) {
    URI.parse "http://api.test/name/v0/lang/db/"
  }

  describe "levels" do
    it "returns the top levels for the database" do
      db.stub(:data, data) do
        db.levels[4].text.
          must_equal "Jord- och skogsbruk, fiske"
      end
    end
  end

  describe "level" do
    it "returns a level" do
      level.class.must_equal subject::Level
    end

    it "has the correct name and text" do
      level.name.must_equal "foo"
      level.text.must_equal "bar"
    end
  end

  describe "table" do
    it "returns a table" do
      table.class.must_equal subject::Table
    end

    it "has the correct name" do
      table.name.must_equal "baz"
    end
  end

  describe "uri" do
    it "returns the correct uri of the database" do
      db.uri.must_equal expected_uri
    end
  end
end
