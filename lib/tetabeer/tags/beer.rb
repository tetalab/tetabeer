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