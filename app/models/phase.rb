class Phase < ApplicationRecord
  has_many :fields, class_name: 'Field'
  has_many :cards, class_name: 'Card'
  belongs_to :pipe, class_name: 'Pipe'
  
  validates_presence_of :name
  
end 