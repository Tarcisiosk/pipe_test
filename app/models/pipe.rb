class Pipe < ApplicationRecord
  ID_TEST = 335557
  belongs_to :organization, class_name: 'Organization'
  has_many :phases, class_name: 'Phase', dependent: :destroy

  validates_presence_of :name

  def self.handle_api_data(data = nil, org)
    return unless data && !org.id.to_i.zero?
    data.each do |pipe_data|
      pipe = self.where(id: pipe_data.dig('id')).first_or_initialize
      pipe.name = pipe_data.dig('name')
      pipe.organization_id = org.id
      pipe.save
      Phase.handle_api_data(pipe_data.dig('phases'), pipe)
    end
  end
end 