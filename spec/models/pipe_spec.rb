require 'rails_helper'

RSpec.describe Pipe, type: :model do
  it { is_expected.to have_many(:phases) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:name) }
  
end
