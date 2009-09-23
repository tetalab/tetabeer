require 'rubygems'
require 'dm-core'

rfid_dev = "/dv/hidraw0"
DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.db")

class RfidTag
  include DataMapper::Resource
  
  property :tag_id, String, :key => true
  property :on_reader, Boolean, :default => false
  
  def self.identify(payload)
    
    # Check if tag exists in DB
    unless tag = RfidTag.first(:tag_id => payload)
      tag = RfidTag.create(:tag_id => payload, :on_reader => true)
    else
      # If tag exists, determine if in/out reader
      tag.switch_reader_state
    end
    
    tag
  end
  
  def switch_reader_state
    if self.on_reader
      self.update_attributes :on_reader => false
    else
      self.update_attributes :on_reader => true
    end
  end
  
end

class BeerTag < RfidTag
  include DataMapper::Resource

  property :credits, Integer, :default => 0
  property :nb_beers, Integer, :default => 0
  
  def has_credit?
    self.remaining_credits > 0
  end
  
  def remaining_credits
    self.credits - self.nb_beers
  end
  
end

class RfidReader
  
  def initialize(device)
     @device = device
  end
  
  def run
    f = File.open(@device, 'r')
    
    while true
        if payload = read_tag
          tag = RfidTag.identify(payload)
          if tag.on_reader
            tag.execute
          end
        end
      end
    end
  end
  
  protected
  
  def read_tag
    a,b = f.read(2).split('').collect {|i| i[0]}                              # read 2 bytes, transform to array and cast to int
    if a == 2
      
      size = f.read(3)[2]                                                     # two 0-bytes (unused) and the payload size
      payload = f.read(size).split('')                                        # read and transform in array
      payload.collect! {|i| i[0].to_s(16)}                                    # cast to int and cast to hex values
      payload = payload.inject {|memo,i| memo += (i.length == 1 ? "0"+i : i)} # prepend 0 to create valid hex values
      zero_byte = f.read(1)                                                   # unused 0-byte
    end
    payload
  end
end

RfidReader.new(rfid_dev)
RfidReader.run