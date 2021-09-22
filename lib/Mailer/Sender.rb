module Mailer
    class Sender
        def self.template(name)
            case name
            when "welcome"
                "this is the welcome layout"
            when "test"
                "This is the test template"
            end
        end

        def self.send(params)
            from = SendGrid::Email.new(email: 'Pent polls <mailer@timetablr.xyz>')
            to = SendGrid::Email.new(email: params[:to])
            subject = params[:subject]
            content = SendGrid::Content.new(
                type: 'text/html', 
                value: template(params[:template_name])
            )
            mail = SendGrid::Mail.new(from, subject, to, content)

            sg = SendGrid::API.new(api_key: ENV['API_KEY'])
            status = sg.client.mail._('send').post(request_body: mail.to_json)
        end

        
    end
end