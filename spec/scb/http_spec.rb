# encoding: utf-8

require_relative '../spec_helper'

describe SCB::HTTP do
  subject { SCB::HTTP }

  describe "headers" do
    it "must set a custom user-agent" do
      expected_ua = "RubyGem: scb (#{SCB::VERSION})"
      subject::HEADERS['User-Agent'].must_equal expected_ua
    end
  end

  describe "Exception" do
    it "must be a RuntimeError" do
      subject::Exception.new.must_be_kind_of RuntimeError
    end
  end
end
