class TetaLab::Rfid::BeerTag
  include DataMapper::Resource
  
  property :tag_id, String, :key => true
  property :on_reader, Boolean, :default => false
  property :credits, Integer, :default => 0
  property :nb_beers, Integer, :default => 0
  
  def has_credit?
    self.remaining_credits > 0
  end
  
  def remaining_credits
    self.credits - self.nb_beers
  end
  
  # === stdlib for rfid
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