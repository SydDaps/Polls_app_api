class TestChannel < ApplicationCable::Channel
  def subscribed
    stream_from "test_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
