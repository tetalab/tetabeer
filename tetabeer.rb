require 'rubygems'
require 'dm-core'

require 'lib/reader'
require 'lib/tag'
require 'lib/tags/beer'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.db")

RfidReader.new("/dev/hidraw0")
RfidReader.run