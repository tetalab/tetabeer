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