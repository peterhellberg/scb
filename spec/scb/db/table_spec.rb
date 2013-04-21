# encoding: utf-8

require_relative '../../spec_helper'

describe SCB::DB::Table do
  subject { SCB::DB::Table }

  let(:name)  { 'LagenhetOmbAkBpAtAr' }
  let(:table) { s(name) }

  describe "initialize" do
    it "takes a name" do
      table.name.must_equal name
    end
  end

  describe "query" do
    it "parses the simple query and loads the JSON" do
      table.stub(:json_query, ->(sq) { sq }) do
        table.query({ Foo: [1,2] }).
          first[:selection][:values].must_equal ["1","2"]
      end
    end
  end

  describe "json_query" do
    it "loads JSON" do
      table.stub(:post_query, '{"foo":123}') do
        table.json_query['foo'].must_equal 123
      end
    end
  end

  describe "png_query" do
    it "parses the simple_query and sets the format to png" do
      table.stub(:post_query, ->(q, f){ [q,f] }) do
        response = table.png_query({ Foo: 1 }, "bar")

        response[0].must_equal [{
          code: "Foo",
          selection: {
            filter: "bar",
            values: ["1"]
          }
        }]

        response[1].must_equal "png"
      end
    end
  end

  describe "post_query" do
    it "rescues any http exception and raises its own instead" do
      table.stub(:api_post, ->(n, sq) { raise SCB::HTTP::Exception }) do
        ->{ table.post_query({}) }.must_raise SCB::DB::InvalidQuery
      end
    end
  end

  describe "title" do
    it "extracts the title from the data" do
      table.stub(:data, { 'title' => 'bar' }) do
        table.title.must_equal 'bar'
      end
    end
  end

  describe "uri" do
    it "returns the URI of the table" do
      table.stub(:api_uri, URI) do
        table.uri.must_equal URI
      end
    end
  end

  describe "write_png_query" do
    it "writes the image data to a file" do
      expected = [[{
          code: "Bar",
          selection: { filter: "item", values: ["1"] }
        }], "png" ]

      table.stub(:post_query, ->(*args){ args }) do
        table.stub(:write_file, ->(*args){ args }) do
          table.write_png_query(nil, { Bar: 1 })[1].
            must_equal expected
        end
      end
    end
  end

  describe "write_png_query_raw" do
    it "writes the image data to a file" do
      table.stub(:post_query, ->(*args){ args }) do
        table.stub(:write_file, ->(*args){ args }) do
          table.write_png_query_raw('foo', { Bar: 123 }).
            must_equal ["foo", [{:Bar=>123}, "png"]]
        end
      end
    end
  end
end
