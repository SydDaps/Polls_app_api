module Sender
  class Sms
    def  initialize(params)
      @to = params[:to]
      @voter_link = params[:voter_link]
      @subject = params[:subject]
      @start_at = params[:start_at]
      @end_at = params[:end_at]
      @pass_key = params[:pass_key]
      @poll_title = params[:poll_title]
      @organization_name = params[:organization_name]
      @index_number = params[:index_number]
    end

    def send_hellio
      build_message

      sms_context = {
        senderId: "EvandyPolls",
        msisdn: @to,
        message: @message,
        username: ENV['SMS_USER'],
        password: ENV['SMS_PASS']
      }

      response = HTTP.post("https://api.helliomessaging.com/v1/sms", json: sms_context)
      response = JSON.parse( response.body ).with_indifferent_access
      unless response[:responseCode] == 200
        return false
      end

      true
    end

    def send_arkesel
      build_message

      sms_context = {
        action: "send-sms",
        api_key: ENV['ARKESEL_API_KEY'],
        to: @to,
        from: "EvandyPolls",
        sms: @message
      }

      response = HTTP.get("https://sms.arkesel.com/sms/api", json: sms_context)
      puts "ffff"
      response = JSON.parse( response.body ).with_indifferent_access
      unless response[:code] == "ok"
        return false
      end

      true
    end

    def build_message
      @message = <<~SMS.strip
      Vote in the #{@poll_title} which starts on #{@start_at} and ends on #{@end_at} with the details below:

      Pass key: #{@pass_key}
      Index number: #{@index_number}
      Vote link: #{@voter_link}
      SMS
    end
  end
end