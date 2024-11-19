require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe "GET" do
    let!(:company) { FactoryBot.create(:company) }
    let!(:owner) { FactoryBot.create(:user, role: 'owner', company:) }
    let!(:member) { FactoryBot.create(:user, company:) }
    let!(:user) { FactoryBot.create(:user) }

    it "lists own events in chronological order" do
      event_1 = FactoryBot.create(:event, from_date: Date.yesterday)
      event_2 = FactoryBot.create(:event, from_date: Date.today, online: false, city: 'Santiago', country: 'CL')
      event_3 = FactoryBot.create(:event, from_date: Date.yesterday - 1, to_date: Date.yesterday)
      event_4 = FactoryBot.create(:event, from_date: Date.yesterday)
      participant_1 = FactoryBot.create(:event_participant, event: event_1, user:)
      participant_2 = FactoryBot.create(:event_participant, event: event_2, user:)
      participant_3 = FactoryBot.create(:event_participant, event: event_3, user:)
      participant_4 = FactoryBot.create(:event_participant, event: event_4, user: owner)
      request.headers['Authorization'] = "Token #{user.id}"
      get :index,
          params: {
            user_id: user.id
          }
      expect(response).to have_http_status(:ok)
      resp = JSON.parse(response.body)
      expect(resp.length).to eq(3)
      expect(resp[0]['id']).to eq(event_3.id)
      expect(resp[1]['id']).to eq(event_1.id)
      expect(resp[2]['id']).to eq(event_2.id)
      expect(DateTime.parse(resp[0]['from_date'])).to eq(event_3.from_date)
      expect(DateTime.parse(resp[1]['from_date'])).to eq(event_1.from_date)
      expect(DateTime.parse(resp[2]['from_date'])).to eq(event_2.from_date)
      expect(resp[0]['online']).to eq(true)
      expect(resp[1]['online']).to eq(true)
      expect(resp[2]['online']).to eq(false)
      expect(resp[0]['city']).to be_nil
      expect(resp[1]['city']).to be_nil
      expect(resp[2]['city']).to eq('Santiago')
      expect(resp[0]['state']).to be_nil
      expect(resp[1]['state']).to be_nil
      expect(resp[2]['state']).to be_nil
      expect(resp[0]['country']).to be_nil
      expect(resp[1]['country']).to be_nil
      expect(resp[2]['country']).to eq('CL')
    end

    it 'lists own events if no user_id provided' do
      event_1 = FactoryBot.create(:event, from_date: Date.yesterday)
      event_2 = FactoryBot.create(:event, from_date: Date.today, online: false, city: 'Santiago', country: 'CL')
      event_3 = FactoryBot.create(:event, from_date: Date.yesterday - 1, to_date: Date.yesterday)
      event_4 = FactoryBot.create(:event, from_date: Date.yesterday)
      participant_1 = FactoryBot.create(:event_participant, event: event_1, user:)
      participant_2 = FactoryBot.create(:event_participant, event: event_2, user:)
      participant_3 = FactoryBot.create(:event_participant, event: event_3, user:)
      participant_4 = FactoryBot.create(:event_participant, event: event_4, user: owner)
      request.headers['Authorization'] = "Token #{user.id}"
      get :index
      expect(response).to have_http_status(:ok)
      resp = JSON.parse(response.body)
      expect(resp.length).to eq(3)
      expect(resp[0]['id']).to eq(event_3.id)
      expect(resp[1]['id']).to eq(event_1.id)
      expect(resp[2]['id']).to eq(event_2.id)
      expect(DateTime.parse(resp[0]['from_date'])).to eq(event_3.from_date)
      expect(DateTime.parse(resp[1]['from_date'])).to eq(event_1.from_date)
      expect(DateTime.parse(resp[2]['from_date'])).to eq(event_2.from_date)
      expect(resp[0]['online']).to eq(true)
      expect(resp[1]['online']).to eq(true)
      expect(resp[2]['online']).to eq(false)
      expect(resp[0]['city']).to be_nil
      expect(resp[1]['city']).to be_nil
      expect(resp[2]['city']).to eq('Santiago')
      expect(resp[0]['state']).to be_nil
      expect(resp[1]['state']).to be_nil
      expect(resp[2]['state']).to be_nil
      expect(resp[0]['country']).to be_nil
      expect(resp[1]['country']).to be_nil
      expect(resp[2]['country']).to eq('CL')
    end

    it 'does not returns a list if no authentication provided' do
      event_1 = FactoryBot.create(:event, from_date: Date.yesterday)
      event_4 = FactoryBot.create(:event, from_date: Date.yesterday)
      participant_1 = FactoryBot.create(:event_participant, event: event_1, user:)
      participant_4 = FactoryBot.create(:event_participant, event: event_4, user: owner)
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
  describe 'POST' do

  end
  describe 'PATCH' do

  end
  describe 'DELETE' do

  end
end
