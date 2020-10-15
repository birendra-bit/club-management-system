class ApplicationMailer < ActionMailer::Base
  default from: 'kuzuzangpola3@gmail.com'
  # layout 'mailer'
  def welcome_email(user)
    @user = user
    puts('user email: ',@user.email)
    mail(to: @user.email, subject: 'Registeration', body:'Your sign up successful')
  end
end
