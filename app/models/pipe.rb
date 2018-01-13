class Pipe < ApplicationRecord
  has_many :phases, class_name: 'Phase'
  belongs_to :organization, class_name: 'Organization'

  validates_presence_of :name
end 