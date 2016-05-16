Fabricator :product_backlog do
  priority {Faker::Number.between(1, 5)}
  project_id {sequence(:project_id, 1)}
  actual {Faker::Number.between(1, 10)}
  estimate {Faker::Number.between(1, 10)}
  remaining
end
