class WelcomeMailer < ApplicationMailer

    def new_organizer_email(organizer)
        @organizer = organizer
        mail(to: @organizer.email, subject: "Welcone to Pila Polls")

    end
end
