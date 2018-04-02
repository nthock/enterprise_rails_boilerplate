require 'rails_helper'

RSpec.describe SessionService, type: :service do
  before do
    @admin = FactoryBot.create(:admin, name: 'Terence Hoong', email: 'terence@example.com')
  end

  context "correct user and password" do
    before do
      inputs = { email: 'terence@example.com', password: 'password' }
      @user = SessionService.authenticate(inputs)
    end

    it 'user with the correct password should return the user object' do
      expect(@user.id).to eq @admin.id
    end
  end

  context "incorrect password" do
    it 'user with incorrect password should raise an error' do
      inputs = { email: 'terence@example.com', password: 'not_a_password' }
      user = SessionService.authenticate(inputs)
      expect(user).to eq GraphQL::ExecutionError.new("Invalid password")
    end
  end
end
