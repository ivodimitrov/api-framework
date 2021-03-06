include Authorise
include Booking

describe('Restful-booker') do
  let(:payload) do
    BookingPayload.new do
      self.firstname = Faker::Name.first_name
      self.lastname = Faker::Name.last_name
      self.totalprice = Faker::Number.number(digits: 3)
      self.depositpaid = true
      self.checkin = '2010-11-11'
      self.checkout = '2010-12-11'
      self.additionalneeds = 'Breakfast'
    end
  end

  let(:second_payload) do
    BookingPayload.new do
      self.firstname = Faker::Name.first_name
      self.lastname = Faker::Name.last_name
      self.totalprice = Faker::Number.number(digits: 3)
      self.depositpaid = true
      self.checkin = '2010-11-11'
      self.checkout = '2010-12-11'
      self.additionalneeds = 'Breakfast'
    end
  end

  let(:partial_payload) do
    BookingPayload.new do
      self.firstname = Faker::Name.first_name
      self.lastname = Faker::Name.last_name
    end
  end

  let(:auth_payload) do
    AuthorisePayload.new do
      self.username = 'admin'
      self.password = 'password123'
    end
  end

  let(:booking_id) do
    response = Booking.create_booking(payload.to_json)
    JSON.parse(response.body)['bookingid']
  end

  it('GET /booking should return a 200') do
    response = Booking.all_bookings

    expect(response.code).to be 200
  end

  it('GET /booking/{id} should return a 200') do
    response = Booking.specific_booking(booking_id, :json)

    expect(response.code).to be 200
  end

  it('GET /booking/{id} should return a 418 when sent a bad accept header') do
    response = Booking.specific_booking(booking_id, :text)

    expect(response.code).to be 418
  end

  it('GET /booking filter by name') do
    Booking.create_booking(payload.to_json)
    response = Booking.filter_booking_by_name(payload.firstname, payload.lastname)

    expect(response.code).to be 200
  end

  it('POST /booking should return a 200') do
    response = Booking.create_booking(payload.to_json)

    expect(response.code).to be 200
  end

  it('POST /booking should return first name') do
    response = Booking.create_booking(payload.to_json)

    expect(JSON.parse(response.body)['booking']['firstname']).to eq payload.firstname
  end

  it('POST /booking should return last name') do
    response = Booking.create_booking(payload.to_json)

    expect(JSON.parse(response.body)['booking']['lastname']).to eq payload.lastname
  end

  it('POST /booking should return total price') do
    response = Booking.create_booking(payload.to_json)

    expect(JSON.parse(response.body)['booking']['totalprice']).to eq payload.totalprice
  end

  it('POST /booking should return deposit paid') do
    response = Booking.create_booking(payload.to_json)

    expect(JSON.parse(response.body)['booking']['depositpaid']).to be true
  end

  it('POST /booking should return check-in date') do
    response = Booking.create_booking(payload.to_json)

    expect(JSON.parse(response.body)['booking']['bookingdates']['checkin']).to eq payload.checkin
  end

  it('POST /booking should return check-out date') do
    response = Booking.create_booking(payload.to_json)

    expect(JSON.parse(response.body)['booking']['bookingdates']['checkout']).to eq payload.checkout
  end

  it('POST /booking should return additional needs') do
    response = Booking.create_booking(payload.to_json)

    expect(JSON.parse(response.body)['booking']['additionalneeds']).to eq payload.additionalneeds
  end

  it('DELETE /booking/{id} should return a 201') do
    created_response = Booking.create_booking(payload.to_json)
    auth_response = Authorise.post_credentials(auth_payload.to_json)
    delete_response = Booking.delete_booking(JSON.parse(created_response.body)['bookingid'],
                                             JSON.parse(auth_response.body)['token'])

    expect(delete_response.code).to be 201
  end

  it('PUT /booking/{id} updating a current booking should return a 200') do
    created_response = Booking.create_booking(payload.to_json)
    auth_response = Authorise.post_credentials(auth_payload.to_json)
    update_response = Booking.update_booking(JSON.parse(created_response.body)['bookingid'],
                                             second_payload.to_json,
                                             JSON.parse(auth_response.body)['token'])

    expect(update_response.code).to be 200
  end

  it('PUT /booking/{id} updating a current booking should return an updated payload') do
    created_response = Booking.create_booking(payload.to_json)
    auth_response = Authorise.post_credentials(auth_payload.to_json)
    update_response = Booking.update_booking(JSON.parse(created_response.body)['bookingid'],
                                             second_payload.to_json,
                                             JSON.parse(auth_response.body)['token'])

    expect(update_response.body).to eq second_payload.to_json
  end

  it('PATCH /booking/{id} partial updating a current booking should return a 200') do
    created_response = Booking.create_booking(payload.to_json)
    auth_response = Authorise.post_credentials(auth_payload.to_json)
    update_response = Booking.partial_update_booking(JSON.parse(created_response.body)['bookingid'],
                                                     partial_payload.to_json,
                                                     JSON.parse(auth_response.body)['token'])

    expect(update_response.code).to be 200
  end
end
