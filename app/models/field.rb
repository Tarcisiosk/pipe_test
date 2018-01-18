class Field < ApplicationRecord
  belongs_to :card, class_name: 'Card'
  
  validates_presence_of :name

  def self.handle_api_data(data = nil, card)
    return unless data && !card.id.to_i.zero?
    data.each do |field_data|
      field = self.where(card_id: card.id, name: field_data.dig('name')).first_or_initialize
      field.name = field_data.dig('name')
      field.value = field_data.dig('value')
      field.card_id = card.id
      field.save
    end
  end

end 