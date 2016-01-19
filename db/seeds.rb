users = [
  # Username | Password | Active | Level
  ['admin', 'admin123', true, 1],
  ['test0', 'test123', false, 1]
]

users.each do |username, password, active, level|
  User.create(username: username, password: password, active: active, level: level)
end
