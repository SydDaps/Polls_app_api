module Sender
  class Sms
    def self.send(params)
      puts "hhhhhh"
      message = <<~SMS.strip
      #{params[:poll_title]}.
      Pass key: #{params[:pass_key]}
      Vote link: #{params[:voter_link]}
      SMS

      sms_context = {
        senderId: "EvandyPolls",
        msisdn: params[:to],
        message: message,
        username: ENV['SMS_USER'],
        password: ENV['SMS_PASS']
      }

     response = HTTP.post("https://api.helliomessaging.com/v1/sms", json: sms_context)
     response = JSON.parse response.body
     puts response
    end
  end
end
