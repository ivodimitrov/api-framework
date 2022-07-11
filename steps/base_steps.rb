module BaseSteps
  def generate_payload(partial: false, extra_parameter: false)
    BookingPayload.new do
      self.firstname = Faker::Name.first_name
      self.lastname = Faker::Name.last_name
      unless partial
        self.totalprice = Faker::Number.number(digits: 3)
        self.depositpaid = Faker::Boolean.boolean
        self.checkin = Faker::Date.forward(days: 0).strftime '%F'
        self.checkout = Faker::Date.forward(days: 20).strftime '%F'
        self.additionalneeds = Faker::Food.description
      end
      self.extra_parameter = Faker::Lorem.word unless extra_parameter
    end
  end

  def auth_response(username: nil, password: nil)
    auth_payload = AuthorisePayload.new do
      username = 'admin' if username.nil?
      password = 'password123' if password.nil?

      self.username = username
      self.password = password
    end

    Authorise.post_credentials(auth_payload.to_json)
  end

  def auth_response_token(username: nil, password: nil)
    response = auth_response(username: username, password: password)
    JSON.parse(response.body)['token']
  end

  def booking_id
    response = Booking.create_booking(generate_payload.to_json)
    JSON.parse(response.body)['bookingid']
  end
end
