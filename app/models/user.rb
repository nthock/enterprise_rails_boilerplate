class User < ApplicationRecord
  attr_accessor :skip_password_validation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :invited_by_id, presence: true, if: :invited_user?
  enum status: { active: 1, invited: 2 }

  def send_reset_password_request
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    UserMailer.reset_password(user).deliver_now
    self.reload
  end

  private

    def password_required?
      return false if skip_password_validation
      super
    end

    def clear_reset_password_token
      self.reset_password_token = nil
      self.reset_password_sent_at = nil
      self.save!
    end

    def invited_user?
      invitation_created_at.present?
    end
end
