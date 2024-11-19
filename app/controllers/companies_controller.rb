class CompaniesController < ApplicationController
  before_action :validate_membership
  def show
    @company = Company.find(params[:id])
    render json: @company, status: :ok
  end

  private

  def validate_membership
    render status: :forbidden if params[:id] != @user.company_id.to_s
  end
end
