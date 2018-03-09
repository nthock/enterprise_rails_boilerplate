class SessionService
  def self.authenticate(inputs)
    user = User.find_by(email: inputs[:email])
    if user && user&.valid_password?(inputs[:password])
      hmac_secret = Rails.application.secrets.hmac_secret
      user_hash = { id: user.id, email: user.email, admin: user.admin, super_admin: user.super_admin }
      token = JWT.encode(user_hash.as_json, hmac_secret, 'HS256')
      user
    else
      GraphQL::ExecutionError.new("Invalid password")
    end
  end
end
