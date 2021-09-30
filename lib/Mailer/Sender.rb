module Mailer
    class Sender
        def self.template(name, data = nil)
            case name
            when "welcome"
                "this is the welcome layout"
            when "publish"
                "poll_link: https://epic-polls.netlify.app/vote/#{ data[:poll_id] }\n \npass_key: #{ data[:pass_key] }"
            end
        end

        def self.send(params)
            from = SendGrid::Email.new(email: 'Pent polls <mailer@timetablr.xyz>')
            to = SendGrid::Email.new(email: params[:to])
            subject = params[:subject]
            content = SendGrid::Content.new(
                type: 'text/html', 
                value: template(params[:template_name], params[:template_data])
            )
            mail = SendGrid::Mail.new(from, subject, to, content)

            sg = SendGrid::API.new(api_key: ENV['API_KEY'])
            status = sg.client.mail._('send').post(request_body: mail.to_json)
        end

        
    end
end