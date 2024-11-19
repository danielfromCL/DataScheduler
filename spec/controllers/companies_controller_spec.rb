require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  describe "GET" do
    let!(:company) { FactoryBot.create(:company) }
    let!(:owner) { FactoryBot.create(:user, company:, role: 'owner') }
    let!(:member) { FactoryBot.create(:user, company:) }
    let!(:outsider) { FactoryBot.create(:user) }

    it "shows a company if owner or member" do
      request.headers['authorization'] = authenticate(member)
      get :show,
          params: {
            id: company.id
          }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(company.as_json)

      request.headers['authorization'] = authenticate(owner)
      get :show,
          params: {
            id: company.id
          }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to eq(company.as_json)
    end

    it 'does not show a company if not owner or member' do
      request.headers['authorization'] = authenticate(outsider)
      get :show,
          params: {
            id: company.id
          }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
