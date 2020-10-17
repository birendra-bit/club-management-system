class ApplicationMailer < ActionMailer::Base
  default from: ENV["USER_NAME"] + "@" + ENV["DOMAIN"]
  # layout 'mailer'
  def send_email(user, subject, body)
    @user = user
    mail(to: @user.email, subject: subject, body: body)
  end

  def send_notice_to_all(user, subject, body)
    @user = user

    for u in @user
      if !u.is_admin
        msg = ""
        msg = "Dear #{u.name}\n\n" + body
        send_email(u, subject, msg).deliver_later(wait: 1.minute)
      end
    end
  end
end
