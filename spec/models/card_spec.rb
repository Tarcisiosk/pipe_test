require 'rails_helper'

RSpec.describe Card, type: :model do
  it { is_expected.to belong_to(:phase) }
  it { is_expected.to validate_presence_of(:name) }
  
end
