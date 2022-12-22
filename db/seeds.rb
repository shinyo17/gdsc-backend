many = 200 - User.count
many = 0 if many < 0
many.times do |i|
  name = "#{Faker::Name.last_name}#{Faker::Name.first_name}"
  email = "#{Faker::Internet.email}"
  phone = Faker::PhoneNumber.cell_phone
  phone = phone.gsub(" ", "").gsub(".", "").gsub("(", "").gsub(")", "").gsub("-", "")
  phone = "010#{phone[0..7]}"
  display_address = "#{Faker::Address.state}#{Faker::Address.city}#{Faker::Address.street_name}"
  password = 'aaabbb111'
  user = { name: name, email: email, phone: phone}
  User.create!(user.merge({ display_address: display_address }))
  StaffUser.create!(user)
  puts "#{i}/#{many}"
end
User.last.update(phone: '01064184332')
last_staff = StaffUser.last
users = User.limit 100
users.each do |user|
  staff = StaffUser.last
  path = '/staff/users'
  body = '이상한 사용자임'
  params = { staff_user_id: staff.id, record: user, path: path, body: body }
  SendStaffCommentService.call(params)
end