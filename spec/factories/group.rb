require 'faker'

FactoryGirl.define do
  factory :group do
    transient do
      admin nil
    end
    sequence(:name) { |n| "group#{n}" }

    after(:build) do |group, evaluator|
      if evaluator.admin.present?
        GroupsUser.create!(
          group: group,
          user: evaluator.admin,
          role: "admin"
        )
      end
    end
  end
end
