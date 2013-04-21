# encoding: utf-8

require_relative '../../spec_helper'

describe SCB::DB::Variable do
  subject { SCB::DB::Variable }

  let(:fixture_file)   { 'sv/ssd/BO/BO0102/LagenhetOmbAkBpAtAr' }
  let(:variables_data) { parsed_fixture(fixture_file)['variables'] }
  let(:data)           { variables_data.sample }
  let(:variable)       { subject.new(data) }

  describe "initialize" do
    it "takes data as input" do
      subject.new("foo").data.must_equal "foo"
    end
  end

  describe "code" do
    it "returns the code of the variable" do
      variable.code.must_equal data["code"]
    end
  end

  describe "text" do
    it "returns the text of the variable" do
      variable.text.must_equal data["text"]
    end
  end

  describe "values" do
    it "returns the values of the variable" do
      variable.values.must_equal data["values"]
    end
  end

  describe "value_texts" do
    it "returns the value texts of the variable" do
      variable.value_texts.must_equal data["valueTexts"]
    end
  end

  describe "elimination?" do
    it "returns true/false if the variable is an elimination" do
      variable.elimination?.must_equal !!data["elimination"]
    end
  end

  describe "time?" do
    it "returns true/false if the variable is a time" do
      variable.time?.must_equal !!data["time"]
    end
  end
end
