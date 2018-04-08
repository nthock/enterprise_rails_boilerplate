require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:super_admin) { FactoryBot.create(:super_admin) }
  let!(:invitation_params) { { name: 'Test Name', email: 'testemail@example.com' } }
  let!(:invited_by_id) { super_admin.id }
  let!(:user) { Invitation::CreateService.new(invitation_params, invited_by_id).invite }

  describe 'invitation' do
    let!(:invitation_email) { UserMailer.invitation(user) }
    
    it 'should be able to send out an invitation email' do
      expect { invitation_email.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by 1
    end

    it 'should have the correct subject line' do
      expect(invitation_email.subject).to eq 'You are invited!!!'
    end

    it 'should send to the correct user' do
      expect(invitation_email.to).to eq [user.email]
    end

    it 'should include the invitation token in the email' do
      expect(invitation_email.html_part.body.to_s).to include user.invitation_token
      expect(invitation_email.text_part.body.to_s).to include user.invitation_token
    end
  end
end
