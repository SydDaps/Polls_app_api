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
      @sender_id = params[:sender_id]
      @phone_number = params[:phone_number]
      @password_set = params[:password_set]
      @temporary_password = params[:temporary_password]
    end

    def send_hellio
      build_message

      sms_context = {
        senderId: @sender_id,
        msisdn: @to,
        message: @message,
        username: ENV['SMS_USER'],
        password: ENV['SMS_PASS']
      }

      begin
        response = HTTP.post("https://api.helliomessaging.com/v1/sms", json: sms_context)
        response_body = JSON.parse(response).with_indifferent_access
      rescue HTTP::TimeoutError => e
        response_body = {
          'status' => 'Failed',
          'error_code' => HTTP::TimeoutError,
          'message' => e.message
        }
      rescue HTTP::ConnectionError => e
        response_body = {
          'status' => 'Failed',
          'error_code' => HTTP::ConnectionError,
          'message' => e.message
        }
      rescue JSON::ParserError
        response_body = { body: response.body.to_s }
      end

      unless response_body[:responseCode] == 200
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
        from: @sender_id,
        sms: @message
      }



      begin
        response = HTTP.get("https://sms.arkesel.com/sms/api", json: sms_context)
        response = JSON.parse( response.body ).with_indifferent_access
      rescue HTTP::TimeoutError => e
        response_body = {
          'status' => 'Failed',
          'error_code' => HTTP::TimeoutError,
          'message' => e.message
        }
      rescue HTTP::ConnectionError => e
        response_body = {
          'status' => 'Failed',
          'error_code' => HTTP::ConnectionError,
          'message' => e.message
        }
      rescue JSON::ParserError
        response_body = { body: response.body.to_s }
      end

      unless response[:code] == "ok"
        return false
      end

      true
    end

    def build_message
      @message = <<~SMS.strip
      Vote in the #{@poll_title} which starts on #{@start_at} and ends on #{@end_at} via #{@voter_link}
      with your phone_number #{@phone_number}
      SMS

      if @password_set
        @message += " and password"
      else
        @message += " and temporary password #{@temporary_password}"
      end
    end
  end
end