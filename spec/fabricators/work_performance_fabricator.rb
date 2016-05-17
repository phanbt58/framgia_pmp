Fabricator :work_performance do
  description {Faker::Lorem.characters}
  plan {Faker::Number.between(1, 10)}
  actual {Faker::Number.between(1, 10)}
  phase_id
  activity_id
end
