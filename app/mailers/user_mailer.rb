class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        puts('user email: ',@user.email)
        mail(to: @user.email, subject: 'Your sign up successful')
    end
end
