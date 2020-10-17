class ApplicationMailer < ActionMailer::Base
  default from: ENV["USER_NAME"] + "@" + ENV["DOMAIN"]
  # layout 'mailer'
  def send_email(user, subject, body)
    @user = user
    mail(to: @user.email, subject: subject, body: body)
  end
end
