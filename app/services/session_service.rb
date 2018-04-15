class SessionService
  def self.authenticate(inputs)
    user = User.find_by(email: inputs[:email])
    if user && user&.valid_password?(inputs[:password])
      user
    else
      GraphQL::ExecutionError.new("Invalid password")
    end
  end
end
