module Helpers
  def generate_user_token(user)
    hmac_secret = Rails.application.secrets.hmac_secret
    JWT.encode(user.as_json, hmac_secret, 'HS256')
  end
end
