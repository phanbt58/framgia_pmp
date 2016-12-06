Fabricator :task do
  subject{Faker::Lorem.sentence}
  description{Faker::Lorem.paragraph}
  spent_time{Faker::Number.between(1, 10)}
  estimate{Faker::Number.between(1, 10)}
  user_id
  sprint_id
end
