Fabricator :project do
  name {Faker::App.name}
  description {Faker::Lorem.sentence}
  start_date {DateTime.new(2016,2,3,8,0,0,"+7")}
  end_date {DateTime.new(2016,2,3,8,0,0,"+7")}
  manager_id
end
