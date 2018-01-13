class Organization < ApplicationRecord
  has_many :pipes, class_name: 'Pipe'
  
  validates_presence_of :name

end 