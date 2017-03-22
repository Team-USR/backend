require 'faker'

FactoryGirl.define do
  factory :group do
    transient do
      admin nil
    end
    sequence(:name) { |n| "group#{n}" }

    after(:build) do |group, evaluator|
      admin = evaluator.admin || FactoryGirl.create(:user)

      GroupsUser.create!(
        group: group,
        user: admin,
        role: "admin"
      )
    end
  end
end
