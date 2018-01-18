class Organization < ApplicationRecord
  ID_TEST = 92858
  has_many :pipes, class_name: 'Pipe', dependent: :destroy

  validates_presence_of :name

  def self.handle_api_data(data = nil)
    return unless data
    organization = self.where(id: ID_TEST).first_or_initialize
    organization.name = data.dig('name')
    organization.save
    Pipe.handle_api_data(data.dig('pipes'), organization)
  end

  def self.org_test
    self.find_by_id(ID_TEST) || nil
  end
end 