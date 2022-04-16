module Sender
  class Sms
    def self.send(params)
      message = <<~SMS.strip
      Vote in the #{params[:poll_title]} which starts on #{params[:start_at]} and ends on #{params[:end_at]} with the details below:
      Pass key: #{params[:pass_key]}
      Index number: #{params[:index_number]}
      Vote link: #{params[:voter_link]}
      SMS

      sms_context = {
        senderId: "EvandyPolls",
        msisdn: params[:to],
        message: message,
        username: ENV['SMS_USER'],
        password: ENV['SMS_PASS']
      }

      puts "----------"
      puts message.length
     response = HTTP.post("https://api.helliomessaging.com/v1/sms", json: sms_context)
     response = JSON.parse response.body
    end
  end
end