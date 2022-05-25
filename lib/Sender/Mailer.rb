module Sender
    class Mailer
        def self.template(name, data = nil)
            case name
            when "welcome"
                "this is the welcome layout"
            when "publish"
                "poll_link: https://epic-polls.netlify.app/vote/#{ data[:poll_id] }\n \npass_key: #{ data[:pass_key] }"

                {
                    poll_name: ""

                }
            end
        end

        def self.send(params)
            data = {
                personalizations: [
                  {
                    to: [
                      {
                        email: params[:to]
                      }
                    ],
                    dynamic_template_data: params[:template_data]
                  }
                ],
                from: {
                  email: ENV['MAIL_FROM'],
                  name: params[:organization_name]
                },
                template_id: params[:template_id]
              }

            sg = SendGrid::API.new(api_key: ENV['API_KEY'])
            status = sg.client.mail._('send').post(request_body: data.to_json)
        end


    end
end