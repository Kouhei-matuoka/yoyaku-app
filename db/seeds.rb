# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             affiliation: "管理者",
             employee_number: 100,
             uid: "abc1",
             admin: true)

emp_num = 100             
2.times do |n|
  name = Faker::Name.name
  email = "superior-#{n+1}@email.com"
  affiliation = "営業部長"
  employee_number = emp_num += 1
  uid = "abd#{n+1}"
  password = "password"
  superior = true
  User.create!(name: name,
               email: email,
               affiliation: affiliation,
               employee_number: employee_number,
               uid: uid,
               password: password, 
               password_confirmation: password,
               superior: superior)
end

emp_num = 102
60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  employee_number = emp_num += 1
  uid = "abe#{n+1}"
  password = "password"
  User.create!(name: name,
               email: email,
               employee_number: employee_number,
               uid: uid,
               password: password,
               password_confirmation: password)
end