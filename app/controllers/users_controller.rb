class UsersController < ApplicationController
  before_action :validate_company
  def index
    @users = @user.company.users
    render json: @users, status: :ok
  end

  private

  def validate_company
    render status: :forbidden if params[:company_id] != @user.company_id.to_s
  end
end
