require 'rails_helper'

RSpec.describe UsersController do
  describe "GET" do
    let!(:company) { FactoryBot.create(:company) }
    let!(:owner) { FactoryBot.create(:user, company:, role: 'owner') }
    let!(:member_1) { FactoryBot.create(:user, company:) }
    let!(:member_2) { FactoryBot.create(:user, company:) }
    let!(:outsider) { FactoryBot.create(:user) }

    it "lists all of a companies' users if owner" do
      request.headers['Authorization'] = authenticate(owner)
      get :index,
          params: {
            company_id: company.id
          }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(3)
      expect(body.map { |m| m['id']}).to match_array([owner.id, member_1.id, member_2.id])
    end

    it 'does not list users if not company member' do
      request.headers['Authorization'] = authenticate(outsider)
      get :index,
          params: {
            company_id: company.id
          }
      expect(response).to have_http_status(:forbidden)
    end

    it 'shows a user itself' do
      request.headers['authorization'] = authenticate(member_1)
      get :show,
          params: {
            id: member_1.id
          }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(member_1.to_json)
    end

    it 'shows a member if owner' do
      request.headers['authorization'] = authenticate(owner)
      get :show,
          params: {
            id: member_1.id
          }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(member_1.to_json)
    end

    it 'does not show user if not from company' do
      request.headers['authorization'] = authenticate(outsider)
      get :show,
          params: {
            id: member_1.id
          }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
