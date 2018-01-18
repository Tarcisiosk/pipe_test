require 'rails_helper'

RSpec.describe Phase, type: :model do
  it { is_expected.to have_many(:cards).dependent(:destroy) }
  it { is_expected.to belong_to(:pipe) }
  it { is_expected.to validate_presence_of(:name) }


  context 'when receiving api data' do
    let(:pipe){ FactoryBot.create(:pipe, id: Pipe::ID_TEST, name: 'name test') }

    context 'with valid params' do
      let(:valid_params) { [{"id"=>"123", "name"=>"Screening", "cards"=> {}}] }

      context 'when new' do
        before { Phase.destroy_all }
        it 'creates a new phase' do
          Phase.handle_api_data(valid_params, pipe)
          expect(Phase.count).to eq 1
          expect(Phase.first.name).to eq valid_params[0]["name"]
        end
      end

      context 'with existent' do
        let(:phase){ FactoryBot.create(:phase, id: 123, name: 'name test') }
        it 'updates the phase' do
          expect(phase.name).to eq 'name test'
          Phase.handle_api_data(valid_params, pipe)
          phase.reload
          expect(phase.name).to eq valid_params[0]["name"]
          expect(phase.pipe_id).to eq pipe.id
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params)  { [{"id"=>"????", "invalid"=>"", "cards"=> {}}] }
      before { Pipe.destroy_all }

      it 'does not save and show no error when invalid' do
        expect{Phase.handle_api_data(invalid_params)}.to_not raise_error
        expect(Phase.count).to eq 0
      end

      it 'does not save and show no error when nil' do
        expect{Phase.handle_api_data(nil)}.to_not raise_error
        expect(Phase.count).to eq 0
      end
    end
  end
  
end
