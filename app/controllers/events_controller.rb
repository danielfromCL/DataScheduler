class EventsController < ApplicationController
  before_action :validate_participant, only: :create
  def index
    @events = get_user.events_ordered_by_from_date
    render json: @events, status: :ok
  end

  def create
    @event = Event.create!(**create_params)
    user = get_user
    EventParticipant.create!(user: @user, event: @event, role: 'creator')
    EventParticipant.create!(user:, event: @event) if user != @user
    render json: @event, status: :created
  end

  private

  def get_user
    if params[:user_id].present?
      User.find(params[:user_id])
    else
      @user
    end
  end

  def create_params
    params.permit(:name, :from_date, :to_date, :online, :city, :country, :state, :url)
  end

  def validate_participant
    render status: :forbidden if @user.role != 'owner' || @user.company_id != get_user.company_id
  end
end
