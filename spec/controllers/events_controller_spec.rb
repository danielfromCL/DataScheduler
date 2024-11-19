require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:company) { FactoryBot.create(:company) }
  let!(:owner) { FactoryBot.create(:user, role: 'owner', company:) }
  let!(:member) { FactoryBot.create(:user, company:) }
  let!(:user) { FactoryBot.create(:user) }
  describe "GET" do
    it "lists own events in chronological order" do
      event_1 = FactoryBot.create(:event, from_date: Date.yesterday)
      event_2 = FactoryBot.create(:event, from_date: Date.today, online: false, city: 'Santiago', country: 'CL')
      event_3 = FactoryBot.create(:event, from_date: Date.yesterday - 1, to_date: Date.yesterday)
      event_4 = FactoryBot.create(:event, from_date: Date.yesterday)
      participant_1 = FactoryBot.create(:event_participant, event: event_1, user:)
      participant_2 = FactoryBot.create(:event_participant, event: event_2, user:)
      participant_3 = FactoryBot.create(:event_participant, event: event_3, user:)
      participant_4 = FactoryBot.create(:event_participant, event: event_4, user: owner)
      request.headers['Authorization'] = authenticate(user)
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
      request.headers['Authorization'] = authenticate(user)
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

    it 'lists workers events if owner' do
      event_1 = FactoryBot.create(:event, from_date: Date.yesterday)
      event_2 = FactoryBot.create(:event, from_date: Date.today, online: false, city: 'Santiago', country: 'CL')
      event_3 = FactoryBot.create(:event, from_date: Date.yesterday - 1, to_date: Date.yesterday)
      event_4 = FactoryBot.create(:event, from_date: Date.yesterday)
      participant_1 = FactoryBot.create(:event_participant, event: event_1, user: member)
      participant_2 = FactoryBot.create(:event_participant, event: event_2, user: member)
      participant_3 = FactoryBot.create(:event_participant, event: event_3, user: member)
      participant_4 = FactoryBot.create(:event_participant, event: event_4, user: owner)
      participant_5 = FactoryBot.create(:event_participant, event: event_3, user: owner, status: 'accepted', role: 'creator')
      request.headers['Authorization'] = authenticate(owner)
      get :index,
          params: {
            user_id: member
          }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(3)
      expect(body[0]['id']).to eq(event_3.id)
      expect(body[1]['id']).to eq(event_1.id)
      expect(body[2]['id']).to eq(event_2.id)
      expect(DateTime.parse(body[0]['from_date'])).to eq(event_3.from_date)
      expect(DateTime.parse(body[1]['from_date'])).to eq(event_1.from_date)
      expect(DateTime.parse(body[2]['from_date'])).to eq(event_2.from_date)
      expect(body[0]['online']).to eq(true)
      expect(body[1]['online']).to eq(true)
      expect(body[2]['online']).to eq(false)
      expect(body[0]['city']).to be_nil
      expect(body[1]['city']).to be_nil
      expect(body[2]['city']).to eq('Santiago')
      expect(body[0]['state']).to be_nil
      expect(body[1]['state']).to be_nil
      expect(body[2]['state']).to be_nil
      expect(body[0]['country']).to be_nil
      expect(body[1]['country']).to be_nil
      expect(body[2]['country']).to eq('CL')
      expect(body[0]['event_participants'].length).to eq(2) # This should have both the owner and the member
      expect(body[1]['event_participants'].length).to eq(1)
      expect(body[2]['event_participants'].length).to eq(1)
      expect(body[0]['event_participants'].map { |ep| ep['id']} ).to match_array([participant_3.id, participant_5.id])
      expect(body[1]['event_participants'][0]['id']).to eq(participant_1.id)
      expect(body[2]['event_participants'][0]['id']).to eq(participant_2.id)
    end

    it 'shows scheduling conflicts' do
      event_1 = FactoryBot.create(:event, from_date: DateTime.parse('2024-11-18T13:00:00-03'), to_date: DateTime.parse('2024-11-18T14:00:00-03'))
      event_2 = FactoryBot.create(:event, from_date: DateTime.parse('2024-11-18T11:00:00-03'), to_date: DateTime.parse('2024-11-18T15:00:00-03'))
      FactoryBot.create(:event_participant, event: event_1, user: member)
      FactoryBot.create(:event_participant, event: event_2, user: member)
      request.headers['Authorization'] = authenticate(owner)
      get :index,
          params: {
            user_id: member.id
          }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(2)
      expect(body[0]['event_participants'][0]['schedule_conflicts']).to eq([event_1.as_json])
      expect(body[1]['event_participants'][0]['schedule_conflicts']).to eq([event_2.as_json])
    end
  end
  describe 'POST' do
    it 'owner can create events for members' do
      request.headers['Authorization'] = authenticate(owner)
      post :create,
           params: {
             user_id: member.id,
             online: false,
             country: 'CL',
             city: 'Santiago',
             from_date: '2024-11-18T12:00:00-03',
             to_date: '2024-11-18T13:00:00-03'
           },
           as: :json
      expect(response).to have_http_status(:created)
      event = Event.find(JSON.parse(response.body)['id'])
      expect(event.country).to eq('CL')
      expect(event.city).to eq('Santiago')
      expect(event.from_date).to eq(DateTime.parse('2024-11-18T12:00:00-03'))
      expect(event.to_date).to eq(DateTime.parse('2024-11-18T13:00:00-03'))
      expect(event.online).to be_falsey
      expect(event.users.count).to eq(2)
      expect(event.users).to eq(User.where(id: [member.id, owner.id]))
      expect(owner.participations.count).to eq(1)
      expect(owner.participations.first.role).to eq('creator')
      expect(owner.participations.first.status).to eq('pending')
      expect(member.participations.count).to eq(1)
      expect(member.participations.first.role).to eq('participant')
      expect(member.participations.first.status).to eq('pending')
    end

    it 'can\'t create events if not owner' do
      request.headers['Authorization'] = authenticate(member)
      post :create,
           params: {
             user_id: owner.id,
             online: false,
             country: 'CL',
             city: 'Santiago',
             from_date: '2024-11-18T12:00:00-03',
             to_date: '2024-11-18T13:00:00-03'
           },
           as: :json
      expect(response).to have_http_status(:forbidden)
      expect(owner.participations.count).to eq(0)
      expect(member.participations.count).to eq(0)
    end

    it 'cant\'t create events for people outside company' do
      request.headers['Authorization'] = authenticate(owner)
      post :create,
           params: {
             user_id: user.id,
             online: false,
             country: 'CL',
             city: 'Santiago',
             from_date: '2024-11-18T12:00:00-03',
             to_date: '2024-11-18T13:00:00-03'
           },
           as: :json
      expect(response).to have_http_status(:forbidden)
      expect(owner.participations.count).to eq(0)
      expect(user.participations.count).to eq(0)
    end

    it 'shows conflict of schedule on creation' do
      event_1 = FactoryBot.create(:event, from_date: DateTime.parse('2024-11-18T13:00:00-03'), to_date: DateTime.parse('2024-11-18T14:00:00-03'))
      FactoryBot.create(:event_participant, event: event_1, user: member)
      request.headers['Authorization'] = authenticate(owner)
      post :create,
           params: {
             user_id: member.id,
             online: false,
             country: 'CL',
             city: 'Santiago',
             from_date: '2024-11-18T13:30:00-03',
             to_date: '2024-11-18T14:00:00-03'
           },
           as: :json
      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['event_participants'].length).to eq(2)
      expect(body['event_participants'][0]['schedule_conflicts']).to eq([])
      expect(body['event_participants'][1]['schedule_conflicts']).to eq([event_1.as_json])
    end

    it 'shows multiple conflicts of schedule on creation' do
      event_1 = FactoryBot.create(:event, from_date: DateTime.parse('2024-11-18T13:00:00-03'), to_date: DateTime.parse('2024-11-18T14:00:00-03'))
      event_2 = FactoryBot.create(:event, from_date: DateTime.parse('2024-11-18T11:00:00-03'), to_date: DateTime.parse('2024-11-18T15:00:00-03'))
      FactoryBot.create(:event_participant, event: event_1, user: member)
      FactoryBot.create(:event_participant, event: event_2, user: member)
      FactoryBot.create(:event_participant, event: event_2, user: owner)
      request.headers['Authorization'] = authenticate(owner)
      post :create,
           params: {
             user_id: member.id,
             online: false,
             country: 'CL',
             city: 'Santiago',
             from_date: '2024-11-18T13:30:00-03',
             to_date: '2024-11-18T14:00:00-03'
           },
           as: :json
      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['event_participants'].length).to eq(2)
      expect(body['event_participants'][0]['schedule_conflicts']).to eq([event_2.as_json])
      expect(body['event_participants'][1]['schedule_conflicts']).to match_array([event_1.as_json, event_2.as_json])
    end

    context 'with mailing' do
      let!(:generic_stub) { stub_request(:post, "https://api.sendgrid.com/v3/mail/send") }
      let!(:member_email_stub_1) {
        stub_request(:post, "https://api.sendgrid.com/v3/mail/send")
          .with(body: "{\"from\":{\"email\":\"datascheduler@dscope.com\",\"name\":\"DataScheduler\"},\"subject\":\"New event scheduled\",\"personalizations\":[{\"to\":[{\"email\":\"#{member.email}\",\"name\":\"#{member.name}\"}]}],\"content\":[{\"type\":\"text/html\",\"value\":\"An event has been scheduled.\\n        Date: 18 Nov 15:00-18 Nov 16:00\\nLocation: Santiago - CL\"}]}")
          .to_return(status: 200, body: "", headers: {})
      }
      let!(:owner_email_stub_1) {
        stub_request(:post, "https://api.sendgrid.com/v3/mail/send")
          .with(body: "{\"from\":{\"email\":\"datascheduler@dscope.com\",\"name\":\"DataScheduler\"},\"subject\":\"New event scheduled\",\"personalizations\":[{\"to\":[{\"email\":\"#{owner.email}\",\"name\":\"#{owner.name}\"}]}],\"content\":[{\"type\":\"text/html\",\"value\":\"An event has been scheduled.\\n        Date: 18 Nov 15:00-18 Nov 16:00\\nLocation: Santiago - CL\"}]}")
          .to_return(status: 200, body: "", headers: {})
      }
      let!(:member_email_stub_2) {
        stub_request(:post, "https://api.sendgrid.com/v3/mail/send")
          .with(body: "{\"from\":{\"email\":\"datascheduler@dscope.com\",\"name\":\"DataScheduler\"},\"subject\":\"New event scheduled\",\"personalizations\":[{\"to\":[{\"email\":\"#{member.email}\",\"name\":\"#{member.name}\"}]}],\"content\":[{\"type\":\"text/html\",\"value\":\"An event has been scheduled.\\n        Date: 18 Nov 15:00-18 Nov 16:00\\nMeeting link: zoom.com\"}]}")
          .to_return(status: 200, body: "", headers: {})
      }
      let!(:owner_email_stub_2) {
        stub_request(:post, "https://api.sendgrid.com/v3/mail/send")
          .with(body: "{\"from\":{\"email\":\"datascheduler@dscope.com\",\"name\":\"DataScheduler\"},\"subject\":\"New event scheduled\",\"personalizations\":[{\"to\":[{\"email\":\"#{owner.email}\",\"name\":\"#{owner.name}\"}]}],\"content\":[{\"type\":\"text/html\",\"value\":\"An event has been scheduled.\\n        Date: 18 Nov 15:00-18 Nov 16:00\\nMeeting link: zoom.com\"}]}")
          .to_return(status: 200, body: "", headers: {})
      }

      it 'notifies users on event creation' do
        request.headers['Authorization'] = authenticate(owner)
        post :create,
             params: {
               user_id: member.id,
               online: false,
               country: 'CL',
               city: 'Santiago',
               from_date: '2024-11-18T12:00:00-03',
               to_date: '2024-11-18T13:00:00-03'
             },
             as: :json
        expect(response).to have_http_status(:created)
        expect(member_email_stub_1).to have_been_requested
        expect(owner_email_stub_1).to have_been_requested
      end

      it 'notifies users with url if event online' do
        request.headers['Authorization'] = authenticate(owner)
        post :create,
             params: {
               user_id: member.id,
               online: true,
               url: 'zoom.com',
               from_date: '2024-11-18T12:00:00-03',
               to_date: '2024-11-18T13:00:00-03'
             },
             as: :json
        expect(response).to have_http_status(:created)
        expect(member_email_stub_2).to have_been_requested
        expect(owner_email_stub_2).to have_been_requested
      end

      it 'does not notify unless created' do
        request.headers['Authorization'] = authenticate(owner)
        post :create,
             params: {
               user_id: user.id,
               online: true,
               url: 'zoom.com',
               from_date: '2024-11-18T12:00:00-03',
               to_date: '2024-11-18T13:00:00-03'
             },
             as: :json
        expect(response).to have_http_status(:forbidden)
        expect(generic_stub).not_to have_been_requested
      end
    end
  end
end
