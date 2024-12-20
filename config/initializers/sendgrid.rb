class SendgridAPI

  def initialize
    @api_key = ENV['SENDGRID_API_KEY']
  end

  def send_email(from, to, subject, content)
    mail = SendGrid::Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(api_key: @api_key)
    sg.client.mail._('send').post(request_body: mail.to_json)
  end
end

Sendgrid = SendgridAPI.new