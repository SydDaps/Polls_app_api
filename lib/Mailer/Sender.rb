module Mailer
    class Sender
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
            # from = SendGrid::Email.new(email: 'Pent polls <mailer@timetablr.xyz>')
            # to = SendGrid::Email.new(email: params[:to])
            # subject = params[:subject]
            # content = SendGrid::Content.new(
            #     type: 'text/html',
            #     value: template(params[:template_name], params[:template_data])
            # )
            # mail = SendGrid::Mail.new(from, subject, to, content)
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
                  email: "mailer@timetablr.xyz",
                  name: "Evandy JCR elections 2022"
                },
                template_id: "d-16b4b7d6a5f94bfa992b41a43a5cdcc7"
              }

            sg = SendGrid::API.new(api_key: ENV['API_KEY'])
            status = sg.client.mail._('send').post(request_body: data.to_json)
        end


    end
end