require 'rails_helper'

RSpec.describe Phase, type: :model do
  it { is_expected.to have_many(:fields) }
  it { is_expected.to have_many(:cards) }
  it { is_expected.to belong_to(:pipe) }
  it { is_expected.to validate_presence_of(:name) }
  
end
