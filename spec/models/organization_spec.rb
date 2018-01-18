require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { is_expected.to have_many(:pipes).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }

  context 'when receiving api data' do
    context 'with valid params' do
      let(:valid_params) { {"name"=>"Pipefy Recruitment Test", "pipes"=> [] } }

      context 'when new' do
        before { Organization.destroy_all }
        it 'creates a new organization' do
          Organization.handle_api_data(valid_params)
          expect(Organization.count).to eq 1
          expect(Organization.first.name).to eq valid_params["name"]
        end
      end

      context 'with existent' do
        let(:organization){ FactoryBot.create(:organization, id: Organization::ID_TEST, name: 'name test') }
        it 'updates the organization' do
          expect(organization.name).to eq 'name test'
          Organization.handle_api_data(valid_params)
          organization.reload
          expect(organization.name).to eq valid_params["name"]
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params) {{"notaorganization"=> {"name"=>"Pipefy Recruitment Test", "pipes"=> [] }}}
      before { Organization.destroy_all }

      it 'does not save and show no error when invalid' do
        expect{Organization.handle_api_data(invalid_params)}.to_not raise_error
        expect(Organization.count).to eq 0
      end

      it 'does not save and show no error when nil' do
        expect{Organization.handle_api_data(nil)}.to_not raise_error
        expect(Organization.count).to eq 0
      end
    end
  end
end
