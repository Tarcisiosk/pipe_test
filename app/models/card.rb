class Card < ApplicationRecord
  belongs_to :phase, class_name: 'Phase'
 
  validates_presence_of :name
end 