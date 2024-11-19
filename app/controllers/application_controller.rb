class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :set_user

  private

  # Very basic, using the user's token as it's id
  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      User.find_by(id: token)
    end
  end

  def set_user
    @user ||= authenticate
  end
end
