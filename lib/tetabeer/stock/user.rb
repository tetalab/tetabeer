class User
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  has n, :tags
  has n, :orders
  
end