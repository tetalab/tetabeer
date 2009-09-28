class TetaBeer::Product
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :price, Float
  
  has n, :orders
  
end