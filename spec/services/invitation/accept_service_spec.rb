require 'rails_helper'

RSpec.describe Invitation::AcceptService, type: :service do
  let!(:super_admin) { FactoryBot.create(:super_admin) }
  let!(:invitation_params) { { name: 'Test Name', email: 'testemail@example.com' } }
  let!(:invited_by_id) { super_admin.id }

  before do
    Invitation::CreateService.new(invitation_params, invited_by_id).invite
  end

  context 'valid invitation_token' do
    it 'should update the invitee with encrypted password, invitation_accepted_at and invitation_accepted' do
      user = User.find_by(email: "testemail@example.com")
      accept_params = { invitation_token: user.invitation_token, password: 'password', password_confirmation: 'password' }
      Invitation::AcceptService.new(accept_params).update
      user.reload
      expect(user.encrypted_password).to be_truthy
      expect(user.invitation_accepted_at).to be_truthy
      expect(user.invitation_accepted).to be true
      expect(user.invitation_token).to be nil
      expect(user.status).to eq 'active'
    end
  end

  context 'invalid invitation token' do
    it 'should return the invalid user error' do
      user = User.find_by(email: "testemail@example.com")
      accept_params = { invitation_token: user.invitation_token, password: 'password', password_confirmation: 'password' }
      Invitation::AcceptService.new(accept_params).update
      invalid_invitation_user = Invitation::AcceptService.new(accept_params).update
      expect(invalid_invitation_user.errors.messages[:invalid_user]).to eq ['User is not valid or invitation has been accepted']
    end
  end
end

# 3621cb08f775c03ecfb8acfc48406e5c3a723f7fd710e85c7f6ac08b2f3d23fc
