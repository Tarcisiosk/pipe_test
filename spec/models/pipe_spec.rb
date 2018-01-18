require 'rails_helper'

RSpec.describe Pipe, type: :model do
  it { is_expected.to have_many(:phases).dependent(:destroy) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:name) }

  context 'when receiving api data' do
    let(:organization){ FactoryBot.create(:organization, id: Organization::ID_TEST, name: 'name test') }

    context 'with valid params' do
      let(:valid_params) { [{"id"=>"335557", "name"=>"Back-end Test", "phases"=> []}] }

      context 'when new' do
        before { Pipe.destroy_all }
        it 'creates a new pipe' do
          Pipe.handle_api_data(valid_params, organization)
          expect(Pipe.count).to eq 1
          expect(Pipe.first.name).to eq valid_params[0]["name"]
          expect(Pipe.first.organization_id).to eq organization.id
        end
      end

      context 'with existent' do
        let(:pipe){ FactoryBot.create(:pipe, id: Pipe::ID_TEST, name: 'name test') }
        it 'updates the pipe' do
          expect(pipe.name).to eq 'name test'
          Pipe.handle_api_data(valid_params, organization)
          pipe.reload
          expect(pipe.name).to eq valid_params[0]["name"]
          expect(pipe.organization_id).to eq organization.id
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params)  { [{"id"=>"????", "invalid"=>"", "phases"=> []}] }
      before { Pipe.destroy_all }

      it 'does not save and show no error when invalid' do
        expect{Pipe.handle_api_data(invalid_params)}.to_not raise_error
        expect(Pipe.count).to eq 0
      end

      it 'does not save and show no error when nil' do
        expect{Pipe.handle_api_data(nil)}.to_not raise_error
        expect(Pipe.count).to eq 0
      end
    end
  end
  
end
