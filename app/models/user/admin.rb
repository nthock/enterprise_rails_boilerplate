class User::Admin < User
  def self.create(inputs)
    User.create(
      name: inputs[:name],
      email: inputs[:email],
      password: inputs[:password],
      password_confirmation: inputs[:password],
      admin: true
    )
  end

  def self.all
    User.where(admin: true)
  end
end
