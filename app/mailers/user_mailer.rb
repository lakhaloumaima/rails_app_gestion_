class UserMailer < ApplicationMailer
    default from: 'oumaima@admin.com'


    def registration_confirmation(user)
      @user = user
      mail(:to => "#{user.last_name} <#{user.email}>", :subject => "Registration Confirmation")
    end
  
   

end
