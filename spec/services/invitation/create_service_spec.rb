require 'rails_helper'

RSpec.describe Invitation::CreateService, type: :service do
  describe 'invite' do
    let!(:super_admin) { FactoryBot.create(:super_admin) }
    let!(:invitation_params) { { name: "Test Name", email: "testemail@example.com" } }
    let!(:invited_by_id) { super_admin.id }

    context 'successful invite' do
      it 'should be able to create an user' do
        expect { Invitation::CreateService.new(invitation_params, invited_by_id).invite }.to change { User.count }.by 1
      end

      it 'should have a random invitation token created and saved' do
        user = Invitation::CreateService.new(invitation_params, invited_by_id).invite
        expect(user.invitation_token).to_not be nil
      end

      it 'should call the UserMailer.invitation once' do
        delivery = double
        expect(delivery).to receive(:deliver_now)
        expect(UserMailer).to receive(:invitation).once.and_return(delivery)

        Invitation::CreateService.new(invitation_params, invited_by_id).invite
      end
    end

    context 'unsuccessful invite' do
      it 'should not be able to create a user if the email is missing' do
        invitation_params[:email] = nil
        expect { Invitation::CreateService.new(invitation_params, invited_by_id).invite }.to change { User.count }.by(0)
      end

      it 'should not be able to create a user if the email format is not right' do
        invitation_params[:email] = "notavalidemail"
        expect { Invitation::CreateService.new(invitation_params, invited_by_id).invite }.to change { User.count }.by(0)
      end

      it 'should not be able to create a user if the name is missing' do
        invitation_params[:name] = nil
        expect { Invitation::CreateService.new(invitation_params, invited_by_id).invite }.to change { User.count }.by(0)
      end

      it 'should not be able to create a user if the user_id is missing' do
        expect { Invitation::CreateService.new(invitation_params, '').invite }.to change { User.count }.by(0)
      end

      it 'should not be able to create a user with the same email address' do
        invitation_params[:email] = super_admin.email
        expect { Invitation::CreateService.new(invitation_params, invited_by_id).invite }.to change { User.count }.by(0)
      end

      it 'should not call the UserMailer.invitation if the invite is unsuccessful' do
        invitation_params[:email] = super_admin.email
        expect(UserMailer).to_not receive(:invitation)

        Invitation::CreateService.new(invitation_params, invited_by_id).invite
      end
    end
  end
end
