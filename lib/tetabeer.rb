require 'rubygems'
require 'dm-core'

require 'tetabeer/reader'
require 'tetabeer/tag'
require 'tetabeer/tags/beer'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.db")

RfidReader.new("/dev/hidraw0")
RfidReader.run