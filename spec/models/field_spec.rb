require 'rails_helper'

RSpec.describe Field, type: :model do
  it { is_expected.to belong_to(:card) }
  it { is_expected.to validate_presence_of(:name) }
  
  context 'when receiving api data' do
    let(:card){ FactoryBot.create(:card, id: 123, title: 'name test') }

    context 'with valid params' do
      let(:valid_params) { [{"name"=>"Whats the bug?", "value"=>"Missing translation on open card"}] }

      context 'when new' do
        before { Field.destroy_all }
        it 'creates a new field' do
          Field.handle_api_data(valid_params, card)
          expect(Field.count).to eq 1
          expect(Field.first.name).to eq valid_params[0]["name"]
          expect(Field.first.value).to eq valid_params[0]["value"]
          expect(Field.first.card_id).to eq card.id
        end
      end

      context 'with existent' do
        let(:field){ FactoryBot.create(:field, card_id: card.id, name: 'Whats the bug?', value: 'test') }
        it 'updates the field' do
          expect(field.value).to eq 'test'
          Field.handle_api_data(valid_params, card)
          field.reload
          expect(field.name).to eq valid_params[0]["name"]
          expect(field.value).to eq valid_params[0]["value"]
          expect(field.card_id).to eq card.id
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params)  { [{"id"=>"????", "invalid"=>"",}] }
      before { Field.destroy_all }

      it 'does not save and show no error when invalid' do
        expect{Field.handle_api_data(invalid_params)}.to_not raise_error
        expect(Field.count).to eq 0
      end

      it 'does not save and show no error when nil' do
        expect{Field.handle_api_data(nil)}.to_not raise_error
        expect(Field.count).to eq 0
      end
    end
  end
end
