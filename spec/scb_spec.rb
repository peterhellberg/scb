# encoding: utf-8

require_relative 'spec_helper'

describe SCB do
  subject { SCB }

  let(:api)   { api_with_test_config(SCB::API.new) }
  let(:level) { subject.level('foo', 'bar', api) }
  let(:table) { subject.table('baz', api) }

  describe "api" do
    it "returns a configured api client" do
      api.config.api_host.must_equal "api.test"
    end

    it "does not memoize the api client" do
      subject.api.object_id.wont_equal subject.api.object_id
    end

    it "can configure the api" do
      api.config.database.must_equal 'db'

      configured_api = subject.api { |c| c.database = 'foo' }
      configured_api.config.database.must_equal 'foo'
    end
  end

  describe "db" do
    it "returns a db instance" do
      subject.db.class.must_equal subject::DB
    end

    it "memoizes the db" do
      subject.db.object_id.must_equal subject.db.object_id
    end
  end

  describe "level" do
    it "returns a level" do
      level.class.must_equal subject::DB::Level
    end

    it "has the correct name and text" do
      level.name.must_equal "foo"
      level.text.must_equal "bar"
    end
  end

  describe "table" do
    it "returns a table" do
      table.class.must_equal subject::DB::Table
    end

    it "has the correct name" do
      table.name.must_equal "baz"
    end
  end
end
