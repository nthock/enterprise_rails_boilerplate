class User < ApplicationRecord
  attr_accessor :skip_password_validation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :invited_by_id, presence: true, if: :invited_user?
  enum status: { active: 1, invited: 2 }

  def issue_token
    user_info = self.slice(:id, :name, :email, :admin, :super_admin, :created_at, :updated_at)
    user_info[:token_issue_time] = Time.now
    hmac_secret = Rails.application.secrets.hmac_secret
    JWT.encode(user_info.as_json, hmac_secret, 'HS256')
  end

  private

    def password_required?
      return false if skip_password_validation
      super
    end

    def invited_user?
      invitation_created_at.present?
    end
end
