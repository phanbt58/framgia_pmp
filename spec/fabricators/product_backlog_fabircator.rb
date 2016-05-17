Fabricator :product_backlog do
  category {sequence(:caterory, 1) {|i| "Category #{i}"}}
  story {sequence(:story, 1) {|i| "Story #{i}"}}
  priority {Faker::Number.between(1, 5)}
  project_id {sequence(:project_id, 1)}
  remaining
end
