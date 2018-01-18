FactoryBot.define do
  factory :card do
    title 'card title'
    creation_date DateTime.now
    due_date DateTime.now
    phase
  end
end
