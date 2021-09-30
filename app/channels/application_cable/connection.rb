module ApplicationCable
  class Connection < ActionCable::Connection::Base
   
    identified_by :current_user

    include ErrorHandler

    def connect
      self.current_user = authorized_user
    end

    private
    
    def authorized_user
      token = request.params[:token]  
      
      unless token
        return reject_unauthorized_connection
      end

      user = JWT::JsonWebToken.decode(token)
      
      return reject_unauthorized_connection  unless user
      

      if user[:organizer_id]
        Organizer.find(user[:organizer_id])
      elsif user[:voter_id]
        Voter.find(user[:voter_id])
      end   
        
    end
    
  end
end
