require 'rest-client'
require './lib/constants/constants'

# Restful-booker only has one resource which is a booking resource.
# Module contains separate functions mapped to different endpoints in restful-booker using rest-client.
module Booking
  def send_get_request(query: nil)
    RestClient.get "#{Constants::ENV_URL}#{query}"
  rescue StandardError => e
    e.response
  end

  def specific_booking(id, accept)
    RestClient.get "#{Constants::ENV_URL}/booking/#{id}", accept: accept
  rescue StandardError => e
    e.response
  end

  def create_booking(payload, accept: :json, content_type: :json)
    RestClient.post "#{Constants::ENV_URL}/booking", payload, accept: accept, content_type: content_type
  rescue StandardError => e
    e.response
  end

  def delete_booking(id:, token: nil)
    RestClient.delete "#{Constants::ENV_URL}/booking/#{id}", cookie: "token=#{token}"
  rescue StandardError => e
    e.response
  end

  def update_booking(id:, payload:, token: nil)
    RestClient.put "#{Constants::ENV_URL}/booking/#{id}",
                   payload,
                   content_type: :json,
                   cookie: "token=#{token}"
  rescue StandardError => e
    e.response
  end

  def partial_update_booking(id:, payload:, token:)
    RestClient.patch "#{Constants::ENV_URL}/booking/#{id}",
                     payload,
                     content_type: :json,
                     cookie: "token=#{token}"
  end
end
