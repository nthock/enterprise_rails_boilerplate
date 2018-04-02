require 'rails_helper'

RSpec.describe User::Admin, type: :model do
  describe 'self.create' do
    it 'should create an admin' do
      inputs = FactoryBot.attributes_for(:user)
      expect { User::Admin.create(inputs, ) }.to change { User.all.count }.by 1
    end
  end
end
