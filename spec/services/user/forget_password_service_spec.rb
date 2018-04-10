require 'rails_helper'

RSpec.describe User::ForgetPasswordService, type: :service do
  let!(:user) { FactoryBot.create(:user) }

  context 'valid user' do
    it 'should be able to generate a reset token' do
      User::ForgetPasswordService.new(user.email).generate
      user.reload
      expect(user.reset_password_token).to_not be nil
      expect(user.reset_password_sent_at).to_not be nil
    end

    it 'should call the UserMailer Reset Password mailer' do
      delivery = double
      expect(delivery).to receive(:deliver_now)
      expect(UserMailer).to receive(:reset_password).once.and_return(delivery)

      User::ForgetPasswordService.new(user.email).generate
    end
  end

  context 'invalid user' do
    it 'should return GraphQL::ExecutionError' do
      invalid_user = User::ForgetPasswordService.new("hello@hello.com").generate
      expect(invalid_user.message).to eq 'Not a valid user'
    end
  end
end
