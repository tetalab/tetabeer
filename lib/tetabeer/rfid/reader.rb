class TetaLab::Rfid::Reader
  
  def initialize(device)
     @device = device
  end
  
  def run
    f = File.open(@device, 'r')
    
    while true
        if payload = Reader.read_tag
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