# Create SuperAdmin
super_admin = User.create(name: "Jimmy", email: "jimmy@example.com", designation: "Founder", password: "password", super_admin: true, admin: true)
