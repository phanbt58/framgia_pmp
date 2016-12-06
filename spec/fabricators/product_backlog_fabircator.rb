Fabricator :product_backlog do
  story_id{sequence(:story_id, 1){|i| "Dev00#{i}"}}
  category{sequence(:caterory, 1){|i| "Category #{i}"}}
  story{sequence(:story, 1){|i| "Story #{i}"}}
  priority{Faker::Number.between(1, 5)}
  project_id
  sprint_id
end
