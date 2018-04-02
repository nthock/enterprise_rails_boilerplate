require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it "should be valid" do
    expect(user).to be_valid
  end

  describe "validations" do
    it "should not be valid when name is missing" do
      user.name = "   "
      expect(user).to_not be_valid
    end

    it "should not be valid when email is missing" do
      user.email = "   "
      expect(user).to_not be_valid
    end

    it "should not be valid when password is missing" do
      user.password = "    "
      expect(user).to_not be_valid
    end
  end

  describe "Admin privilege" do
    it "should have admin field set to false" do
      user.save!
      expect(user.admin).to be false
    end

    it "should have super admin field set to false" do
      user.save!
      expect(user.super_admin).to be false
    end
  end
end
