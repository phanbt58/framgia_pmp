namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating Manager"
    user = Fabricate :user, role: 2, email: "chu.anh.tuan@framgia.com",
      name: "Chu Anh Tuan"

    puts "Success remake data"

    puts "create project"
    10.times do
      Fabricate :project, manager_id: user.id
    end

    puts "create sprint"
    10.times do
      puts "create project"
      Fabricate :sprint, project_id: 1
    end

    puts "create member"
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
  end
end
