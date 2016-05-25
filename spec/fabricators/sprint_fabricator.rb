Fabricator :sprint do
  name {sequence(:name, 1) {|i| "Sprint#{i}"}}
  description {Faker::Lorem.sentence}
  project_id
  start_date Date.today
end
