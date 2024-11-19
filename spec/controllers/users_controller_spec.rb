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
  end
  describe 'POST' do

  end
  describe 'PATCH' do

  end
  describe 'DELETE' do

  end
end
