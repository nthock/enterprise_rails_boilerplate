class User < ApplicationRecord
  attr_accessor :skip_password_validation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :invited_by_id, presence: true, if: :invited_user?

  private

    def password_required?
      return false if skip_password_validation
      super
    end

    def invited_user?
      invitation_created_at.present?
    end
end
