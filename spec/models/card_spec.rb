require 'rails_helper'

RSpec.describe Card, type: :model do
  it { is_expected.to have_many(:fields).dependent(:destroy) }
  it { is_expected.to belong_to(:phase) }
  it { is_expected.to validate_presence_of(:title) }

  context 'when receiving api data' do
    let(:phase){ FactoryBot.create(:phase, name: 'name test') }

    context 'with valid params' do
      let(:valid_params) { [{"node"=> {"id"=>"123", "title"=>"Card Title", "created_at"=>"2017-12-18T15:10:06-02:00", 
                             "due_date"=>"2018-01-01T15:23:59-02:00", "fields"=> []}}] }
      context 'when new' do
        before { Card.destroy_all }
        it 'creates a new card' do
          Card.handle_api_data(valid_params, phase)
          expect(Card.count).to eq 1
          expect(Card.first.title).to eq valid_params[0]["node"]["title"]
          expect(Card.first.creation_date).to eq valid_params[0]["node"]["created_at"]
          expect(Card.first.due_date).to eq valid_params[0]["node"]["due_date"]
        end
      end

      context 'with existent' do
        let(:card){ FactoryBot.create(:card, id: 123, title: 'name test') }
        it 'updates the card' do
          expect(card.title).to eq 'name test'
          Card.handle_api_data(valid_params, phase)
          card.reload
          expect(card.title).to eq valid_params[0]["node"]["title"]
          expect(card.creation_date).to eq valid_params[0]["node"]["created_at"]
          expect(card.due_date).to eq valid_params[0]["node"]["due_date"]
          expect(card.phase_id).to eq phase.id
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params)  { [{"id"=>"????", "invalid"=>"", "fields"=> {}}] }
      before { Card.destroy_all }

      it 'does not save and show no error when invalid' do
        expect{Card.handle_api_data(invalid_params)}.to_not raise_error
        expect(Card.count).to eq 0
      end

      it 'does not save and show no error when nil' do
        expect{Card.handle_api_data(nil)}.to_not raise_error
        expect(Card.count).to eq 0
      end
    end
  end
  
end
