module Sender
  class Text
    def self.send(params)
      message = <<~SMS.strip
      Evandy hostel Elections 2022
      Pass key: "11111111"
      ID: "1111111111"
      Vote link: "https://epic-polls.netlify.app/vote/#{Poll.first.id}"
      SMS
      sms_context = {
        senderId: "EvandyPolls",
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
