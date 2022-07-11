include BaseSteps
include Booking

describe '[GET] Restful-booker' do
  let(:payload) { BaseSteps.generate_payload }

  let(:created_response) { Booking.create_booking(payload.to_json) }

  it 'responds to /ping', tms: '201' do
    response = Booking.send_get_request query: '/ping'

    expect(response.code).to be 201
  end

  it 'responds with a 200 when GET /booking', tms: '202' do
    response = Booking.send_get_request query: '/booking'

    expect(response.code).to be 200
  end

  it 'responds with a payload when GET /booking/{id}', tms: '203' do
    response = Booking.specific_booking(JSON.parse(created_response.body)['bookingid'], :json)

    expect(response.code).to be 200
    expect(response.body).to eq payload.to_json
  end

  it 'responds with a 418 when sent a bad accept header', tms: '204' do
    response = Booking.specific_booking(JSON.parse(created_response.body)['bookingid'], :text)

    expect(response.code).to be 418
  end

  it 'responds with a 200 when searching for first name', tms: '205' do
    response = Booking.send_get_request query: "/booking?firstname=#{payload.firstname}"

    expect(response.code).to be 200
  end

  it 'responds with a 200 when searching for last name', tms: '206' do
    response = Booking.send_get_request query: "/booking?lastname=#{payload.lastname}"

    expect(response.code).to be 200
  end

  it 'responds with a 200 when searching for first name & last name', tms: '207' do
    response = Booking.send_get_request query: "/booking?firstname=#{payload.firstname}&lastname=#{payload.lastname}"

    expect(response.code).to be 200
  end

  it 'responds with a 200 when searching for checkin date', tms: '208' do
    response = Booking.send_get_request query: "/booking?checkin=#{payload.checkin}"

    expect(response.code).to be 200
  end

  it 'responds with a 200 when searching for checkout date', tms: '209' do
    response = Booking.send_get_request query: "/booking?checkout=#{payload.checkout}"

    expect(response.code).to be 200
  end

  it 'responds with a 200 when searching for checkin & checkout date', tms: '210' do
    response = Booking.send_get_request query: "/booking?checkin=#{payload.checkin}&checkout=#{payload.checkout}"

    expect(response.code).to be 200
  end

  it 'responds with a 200 when searching for name, checkin and checkout date', tms: '211' do
    response = Booking.send_get_request query: "/booking?firstname=#{payload.firstname}&lastname=" \
                                               "#{payload.lastname}&#{payload.checkin}&checkout=#{payload.checkout}"

    expect(response.code).to be 200
  end

  it 'responds with a 500 when sent a bad date query string', tms: '212' do
    response = Booking.send_get_request query: '/booking?checkout=2013-02-0'

    expect(response.code).to be 500
  end
end
