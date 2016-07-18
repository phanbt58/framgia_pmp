namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating Manager"
    user = Fabricate :user, role: 2, email: "chu.anh.tuan@framgia.com",
      name: "Chu Anh Tuan"

    puts "Creating project"
    5.times do
      Fabricate :project, manager_id: user.id
    end

    puts "Creating product backlog"
    Project.all.each do |project|
      5.times do
        estimate = Faker::Number.between(4, 16)
        actual = Faker::Number.between(0, 4)
        remaining = estimate - actual

        Fabricate :product_backlog, estimate: estimate, actual: actual,
          remaining: remaining, project_id: project.id
      end
    end

    puts "Creating sprint for each project"
    Project.all.each do |project|
      2.times do
        Fabricate :sprint, project_id: project.id
      end
    end

    puts "Creating member"
    user_hash = {
      "Nguyen Binh Dieu": "nguyen.binh.dieu",
      "Nguyen Thai Son": "nguyen.thai.son",
      "Vu Thi Ngoc": "vu.thi.ngoc",
      "Nguyen Hoang Nam": "nguyen.hoang.nam",
      "Nguyen Van Hien": "nguyen.van.hien",
      "Dao Duy Dat": "dao.duy.dat",
      "Nguyen Dac Truong": "nguyen.dac.truong",
    }
    user_hash.each do |key, value|
      user = Fabricate :user, name: key, email: value+"@framgia.com"
    end

    puts "Add asignee to project 1"
    User.all.each do |user|
      Fabricate :assignee, user_id: user.id, project_id: Project.first.id,
        sprint_id: nil, work_hour: 0
    end

    puts "Add asignee to sprints 1"
    User.all.each do |user|
      as = Fabricate :assignee, user_id: user.id, project_id: nil,
        sprint_id: Sprint.first.id, work_hour: 8
      as.time_logs.each do |time_log|
        time_log.update_attributes lost_hour: 1
      end
    end

    puts "Creating phase"
    ["Line of code", "Unit Test", "Integration Test"].each do |phase|
      Fabricate :phase, phase_name: phase
    end

    puts "Creating activities for the first sprint of project 1"
    Sprint.first.assignees.each do |assignee|
      ac = Fabricate :activity, user_id: assignee.user.id, sprint_id: Sprint.first.id,
        product_backlog_id: ProductBacklog.first.id
      start_log_work = 8
      ac.log_works.each do |log_work|
        log_work.update_attributes remaining_time: start_log_work - 1
        start_log_work -= 1
      end
    end

    puts "Success remake data"
  end
end
