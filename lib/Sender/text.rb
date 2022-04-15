module Sender
  class Text
    def self.send(params)

      sms_context = {
        senderId: "Poll 2022",
        msisdn: '233203669141',
        message: 'Ruby Sending SMS',
        username: 'sydney2131',
        password: 'weWove2131'
      }

     response = HTTP.post("https://api.helliomessaging.com/v1/sms", json: sms_context)
     response = JSON.parse response.body
    end
  end
end
