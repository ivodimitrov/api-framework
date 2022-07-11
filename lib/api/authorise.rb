require 'rest-client'
require './lib/constants/constants'

module Authorise
  def post_credentials(payload)
    RestClient.post "#{Constants::ENV_URL}/auth", payload, content_type: :json
  rescue StandardError => e
    e.to_s
  end
end
