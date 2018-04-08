require "rails_helper"

RSpec.describe 'user mutations', type: :request do
  include Helpers
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:super_admin) { FactoryBot.create(:super_admin) }

  describe 'create_admins' do
    let!(:operation_name) { "addAdmin" }
    let!(:variables) do
      { name: 'test admin',
        email: 'testadmin@example.com' }
    end
    let!(:query) do
      %[
        mutation addAdmin($name: String, $email: String) {
          addAdmin(input: { name: $name, email: $email }) {
            id
            name
            email
            designation
            admin
            super_admin
            errors {
              key
              value
            }
          }
        }
      ]
    end

    context 'normal user' do
      let!(:token) { generate_user_token(user) }
      let!(:headers) { { authorization: "Bearer #{token}" } }

      it 'should return the appropriate error message' do
        post '/graphql', params: { query: query, variables: variables, operationName: operation_name }, headers: headers
        response_data = JSON.parse(response.body)
        expect(response_data['errors'].count).to_not eq 0
        expect(response_data['errors'][0]['message']).to eq 'Not authorised to create admin'
      end
    end

    context 'admin' do
      let!(:token) { generate_user_token(admin) }
      let!(:headers) { { authorization: "Bearer #{token}" } }

      it 'should raise RuntimeError' do
        post '/graphql', params: { query: query, variables: variables, operationName: operation_name }, headers: headers
        response_data = JSON.parse(response.body)
        expect(response_data['errors'].count).to_not eq 0
        expect(response_data['errors'][0]['message']).to eq 'Not authorised to create admin'
      end
    end

    context 'super_admin' do
      let!(:token) { generate_user_token(super_admin) }
      let!(:headers) { { authorization: "Bearer #{token}" } }

      it 'should create one additional admin' do
        expect do
          post '/graphql', params: { query: query, variables: variables, operationName: operation_name }, headers: headers
        end.to change { User.where(admin: true).count }.by 1
      end

      it 'should return the created admin data' do
        post '/graphql', params: { query: query, variables: variables, operationName: operation_name }, headers: headers
        created_admin = JSON.parse(response.body)['data']['addAdmin']
        expect(created_admin['name']).to eq variables[:name]
        expect(created_admin['email']).to eq variables[:email]
        expect(created_admin['super_admin']).to be false
      end
    end
  end

  describe 'send invitation' do
    let!(:token) { generate_user_token(super_admin) }
    let!(:headers) { { authorization: "Bearer #{token}" } }
    let!(:operation_name) { "sendInvite" }
    let!(:invitation_params) { { name: 'Test Name', email: 'testemail@example.com' } }
    let!(:invited_user) { Invitation::CreateService.new(invitation_params, super_admin.id).invite }
    let!(:query) do
      %[
        mutation sendInvite($id: ID) {
          sendInvite(input: { id: $id }) {
            id
            name
            email
            designation
            admin
            super_admin
            errors {
              key
              value
            }
          }
        }
      ]
    end

    it 'should send out a mailer' do
      delivery = double
      expect(delivery).to receive(:deliver_now)
      expect(UserMailer).to receive(:invitation).once.and_return(delivery)

      post '/graphql', params: { query: query, variables: { id: invited_user.id }, operationName: operation_name }, headers: headers
    end
  end

  describe 'Accept user invitation' do
    let!(:operation_name) { "acceptInvite" }
    let!(:invitation_params) { { name: 'Test Name', email: 'testemail@example.com' } }
    let!(:invited_user) { Invitation::CreateService.new(invitation_params, super_admin.id).invite }
    let!(:variables) do
      {
        invitation_token: invited_user.invitation_token,
        password: 'password',
        password_confirmation: 'password'
      }
    end
    let!(:query) do
      %[
        mutation acceptInvite($invitation_token: String, $password: String, $password_confirmation: String) {
          acceptInvite(input: { invitation_token: $invitation_token, password: $password, password_confirmation: $password_confirmation }) {
            id
            name
            email
            designation
            admin
            super_admin
            errors {
              key
              value
            }
          }
        }
      ]
    end

    it 'should return the invited user' do
      post '/graphql', params: { query: query, variables: variables, operationName: operation_name }
      user = JSON.parse(response.body)['data']['acceptInvite']
      expect(user['name']).to eq 'Test Name'
      expect(user['email']).to eq 'testemail@example.com'
    end

    it 'should update the user with invitation accepted' do
      post '/graphql', params: { query: query, variables: variables, operationName: operation_name }
      user = User.find_by(email: "testemail@example.com")
      expect(user.encrypted_password).to be_truthy
      expect(user.invitation_accepted_at).to be_truthy
      expect(user.invitation_accepted).to be true
    end
  end
end
