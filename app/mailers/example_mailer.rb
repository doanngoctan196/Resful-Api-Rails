class ExampleMailer < ApplicationMailer
    def sample_email(user)
        @user = user
        mail(to: @user.email, subject: "Accept Sign Up!")
      end    
end
