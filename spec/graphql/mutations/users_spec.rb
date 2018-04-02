require "rails_helper"

RSpec.describe 'user queries', type: :request do
  include Helpers
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:super_admin) { FactoryBot.create(:super_admin) }
  let!(:variables) do
    { name: 'test admin',
      email: 'testadmin@example.com',
      password: 'password',
      password_confirmation: 'password_confirmation' }
  end
  let!(:operation_name) { "addAdmin" }

  describe 'create_admins' do
    let!(:query) do
      %[
        mutation addAdmin($name: String, $email: String, $password: String, $password_confirmation: String) {
          addAdmin(input: { name: $name, email: $email, password: $password, password_confirmation: $password_confirmation }) {
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
end
