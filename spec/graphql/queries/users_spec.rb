require "rails_helper"

RSpec.describe 'user queries', type: :request do
  include Helpers
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:super_admin) { FactoryBot.create(:super_admin) }

  describe 'all users' do
    let!(:query) do
      %q[
        query {
          users {
            id
            name
            email
            designation
            admin
            super_admin
          }
        }
      ]
    end

    context 'normal user' do
      let!(:token) { generate_user_token(user) }
      let!(:headers) { { authorization: "Bearer #{token}" } }

      it 'should return the error message' do
        post '/graphql', params: { query: query, variables: {} }, headers: headers
        response_data = JSON.parse(response.body)
        expect(response_data['errors'].count).to_not eq 0
        expect(response_data['errors'][0]['message']).to eq 'Not authorised to query all users'
      end
    end

    context 'admin' do
      let!(:token) { generate_user_token(admin) }
      let!(:headers) { { authorization: "Bearer #{token}" } }

      it 'should return all the users' do
        post '/graphql', params: { query: query, variables: {} }, headers: headers
        response_data = JSON.parse(response.body)
        expect(response_data['data']['users'].count).to eq User.count
      end
    end
  end
end
