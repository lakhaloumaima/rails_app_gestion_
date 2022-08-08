class UserMailer < ApplicationMailer
    default from: 'oumaima@admin.com'


    def registration_confirmation(user)
      @user = user
      mail(:to => "#{user.last_name} <#{user.email}>", :subject => "Registration Confirmation")
    end
  
   
  def forgot_password(user)
    @user = user
    @greeting = "Hi"
  
     mail to: user.email, :subject => 'Reset password instructions'
  end

end
