Fabricator :work_performance_data do
  description {Faker::Lorem.sentence}
  plan {Faker::Number.between(1, 10)}
  actual {Faker::Number.between(1, 10)}
  phase_id
  activity_id
end
