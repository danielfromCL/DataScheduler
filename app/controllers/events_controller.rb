class EventsController < ApplicationController
  def index
    @events = get_user.events_ordered_by_from_date
    render json: @events, status: :ok
  end

  private

  def get_user
    if params[:user_id].present?
      User.find(params[:user_id])
    else
      @user
    end
  end
end
