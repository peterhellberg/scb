# SCB

A small API client for the SCB API.

You probably want to read the [API\_beskrivning.pdf](http://www.scb.se/Grupp/OmSCB/Dokument/API_beskrivning.pdf) (in Swedish)

[![Build Status](https://travis-ci.org/peterhellberg/scb.png?branch=master)](https://travis-ci.org/peterhellberg/scb)

## Installation

Add this line to your application's Gemfile:

    gem 'scb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scb

## Usage

It is probably a good idea to take a look in `specs`

Configuration of the API client is done automatically, but it is also possible to manually compose the objects:

```ruby
# Manual composition
config = SCB::API.config.new
api    = SCB::API.new(config)
db     = SCB::DB.new(api)
table  = db.table('ProdbrEl')

# Short form
table = SCB.table('ProdbrEl')

# Liquid renewable energy in 2009
table.query Bransle: 925, Tid: 2009
```

### Configuration

Nothing needs to be configured out of the box, but you can change the
`api_host`, `api_name`, `api_version`, `language`, `database`, 
`http_client` and `json_parser` settings like this:

```ruby
# English config
config = SCB::API::Config.new do |c|
  c.language = 'en'
end

# You can also pass a block straight to SCB.api
SCB.api { |c| c.api_host = 'scb.test' } 
```

### Database

The database is divided into levels/sub-levels and tables.

The default language is 'sv' but there is also some data unde 'en'

```ruby
db = SCB.db

# The names of All the top levels
db.levels.map(&:name)

# English levels under 
db.level(BO0303')

# The English title of LonArb07Privat
SCB.db.en.table('LonArb07Privat').title
```

### Level

The database levels can contain sub-levels or tables. You are probably
more interested in the actual tables and their data. 

```ruby
# All the levels below BO
SCB.level('BO').levels

# All the tables below HE0110A
SCB.level('HE0110A').tables
```

### Table

This is probably where you want to spend most of your time.

You can ask the table for possible variables in order to construct your query. I’ve implemented a simplified query format along the lines: `Key: value` where value is automatically turned into an Array if you only want a single value.

*Note:* Each value is also turned into a string.

```ruby
# Database table containing data on electricity production
table = SCB.table('EltillfM')

# URI to the API endpoint for the table
table.uri

# The variable codes for the table
table.variables.map(&:code)

# Query: Wind production in January and February of 2013
table.query Prodslag: "Vind", Tid: ["2013M01", "2013M02"]

# Usage of the Internet
table = SCB.table('LE0108T05')

table.query Tid: 2012, Dem: "25-34"

# You can also get the result as a png
filename = '/tmp/internet_usage_2011.png'
query    = { AnvOmr: 80, Tid: 2011, ContentsCode: "LE0108A2" }

table.write_png_query(filename, query)
```
*Note:* `write_png_query` will not overwrite existing files.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
