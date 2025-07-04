# Check if super admin already exists
admin = SuperAdmin.find_by(email: 'john@acme.inc')
if admin
  admin.update!(
    password: 'password123',
    password_confirmation: 'password123',
    confirmed_at: Time.now
  )
  puts "Password updated for existing admin: #{admin.email}"
else
  # Create new super admin
  admin = SuperAdmin.create!(
    name: 'Super Admin',
    email: 'admin@example.com',
    password: 'password123',
    password_confirmation: 'password123',
    confirmed_at: Time.now
  )
  puts "Created new admin: #{admin.email}"
end

puts "Admin details:"
puts "Email: #{admin.email}"
puts "Confirmed: #{admin.confirmed?}"
puts "Type: #{admin.type}"