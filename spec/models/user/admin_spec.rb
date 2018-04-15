require 'rails_helper'

RSpec.describe User::Admin, type: :model do
  describe 'self.create' do
    it 'should create an admin' do
      inputs = FactoryBot.attributes_for(:user)
      expect { User::Admin.create(inputs, ) }.to change { User.all.count }.by 1
    end
  end

  describe 'self.all' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin) { FactoryBot.create(:admin) }
    let!(:admin2) { FactoryBot.create(:admin, email: 'admin2@example.com') }
    let!(:admins) { User::Admin.all }

    it 'should return only 2 admins' do
      expect(admins.count).to eq 2
    end

    it 'should not include user' do
      expect(admins).to_not include user
    end
  end
end
