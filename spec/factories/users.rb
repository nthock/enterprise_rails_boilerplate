FactoryBot.define do
  factory :user do
    name "John Doe"
    email "john@example.com"
    password "password"
  end

  factory :admin, class: User do
    name "James"
    email "james@example.com"
    password "password"
    admin true
  end

  factory :super_admin, class: User do
    name "Jimmy"
    email "jimmy@example.com"
    password "password"
    admin true
    super_admin true
  end
end
