require 'rails_helper'

RSpec.describe User::ResetPasswordService, type: :service do
  let!(:user) { FactoryBot.create(:user) }
  let!(:forgot_password_user) { User::ForgetPasswordService.new(user.email).generate }

  it 'should be able to change the password and clear the token' do
    reset_password_params = {
      reset_password_token: forgot_password_user.reset_password_token,
      password: 'another_password',
      password_confirmation: 'another_password'
    }
    updated_user = User::ResetPasswordService.new(reset_password_params).reset_password_and_clear_token
    expect(updated_user.reset_password_token).to be nil
    expect(updated_user.reset_password_sent_at).to be nil
    expect(updated_user.encrypted_password).to_not be eq user.encrypted_password
  end
end
