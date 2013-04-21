# encoding: utf-8

require_relative '../../spec_helper'

describe SCB::DB::Level do
  subject { SCB::DB::Level }

  let(:api) { SCB::API.new }

  let(:level) {
    s('BO', 'Boende, byggande och bebyggelse')
  }

  describe "initialize" do
    it "takes a name" do
      level.name.must_equal 'BO'
    end

    it "also takes an optional text" do
      level.text.must_equal 'Boende, byggande och bebyggelse'
    end
  end

  describe "levels" do
    it "has a list of levels" do
      level.stub(:data, parsed_fixture('sv/ssd/BO')) do
        level.levels.last.name.must_equal 'BO0701'
      end
    end
  end

  describe "tables" do
    it "has a list of tables" do
      level.stub(:data, parsed_fixture('sv/ssd/BO/BO0102')) do
        level.tables[3].name.must_equal 'LagenhetRivAkBpLtRAr'
      end
    end
  end
end
