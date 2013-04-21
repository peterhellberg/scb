# encoding: utf-8

require_relative '../spec_helper'

describe SCB::VERSION do
  subject { SCB::VERSION }

  it "returns a version string" do
    subject.must_match(/^\d+\.\d+\.\d+$/)
  end
end
