Fabricator :work_performance do
  phase_id
  task_id
  item_performance_id
  master_sprint_id
  user_id
  sprint_id
  performance_value {Faker::Number.between(1, 10)}
end
