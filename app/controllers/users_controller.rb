class UsersController < ApplicationController
  before_action :validate_company

  def show
    @user = User.find(params[:id])
    render json: @user, status: :ok
  end

  def index
    @users = @user.company.users
    render json: @users, status: :ok
  end

  private

  def validate_company
    render status: :forbidden if (params[:company_id].present? && params[:company_id] != @user.company_id.to_s) || (params[:id].present? && User.find_by(id: params[:id])&.company_id != @user.company_id)
  end
end
