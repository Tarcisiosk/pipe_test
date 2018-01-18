class Card < ApplicationRecord
  belongs_to :phase, class_name: 'Phase'
  has_many :fields, class_name: 'Field', dependent: :destroy

  validates_presence_of :title

  def self.handle_api_data(data = nil, phase)
    return unless data && !phase.id.to_i.zero?
    data.each do |card_data|
      card = self.where(id: card_data.dig('node', 'id')).first_or_initialize
      card.title = card_data.dig('node', 'title')
      card.due_date = card_data.dig('node', 'due_date')&.to_time
      card.creation_date = card_data.dig('node', 'created_at')&.to_time
      card.phase_id = phase.id
      card.save
      Field.handle_api_data(card_data.dig('node', 'fields'), card)
    end
  end
end