class Phase < ApplicationRecord
  belongs_to :pipe, class_name: 'Pipe'
  has_many :cards, class_name: 'Card', dependent: :destroy
  
  validates_presence_of :name
  
  def self.handle_api_data(data = nil, pipe)
    return unless data && !pipe.id.to_i.zero?
    data.each do |phase_data|
      phase = self.where(id: phase_data.dig('id')).first_or_initialize
      phase.name = phase_data.dig('name')
      phase.pipe_id = pipe.id
      phase.save
      Card.handle_api_data(phase_data.dig('cards', 'edges'), phase)
    end
  end

end 