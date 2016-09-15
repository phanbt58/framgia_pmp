Fabricator :work_performance do
  phase_id
  activity_id
  item_performance_id
  master_sprint_id
  assignee_id
  sprint_id
  performance_value {Faker::Number.between(1, 10)}
end
