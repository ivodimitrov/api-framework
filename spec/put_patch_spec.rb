include Authorise
include BaseSteps
include Booking

describe '[PUT/PATCH] Restful-booker' do
  let(:second_payload) { BaseSteps.generate_payload.to_json }

  let(:partial_payload) { BaseSteps.generate_payload partial: true }

  it 'responds with a 200 and an updated payload', tms: '401' do
    response = Booking.update_booking(id: BaseSteps.booking_id,
                                      payload: second_payload,
                                      token: BaseSteps.auth_response_token)

    expect(response.code).to be 200
    expect(response.body).to eq second_payload
  end

  it 'responds with a 200 and an updated first and last name', tms: '402' do
    response = Booking.partial_update_booking(id: BaseSteps.booking_id,
                                              payload: partial_payload.to_json,
                                              token: BaseSteps.auth_response_token)

    expect(response.code).to be 200
    expect(response.body).to include(partial_payload.firstname).and include(partial_payload.lastname)
  end

  it 'responds with a 403 when no token is sent', tms: '403' do
    response = Booking.update_booking(id: BaseSteps.booking_id,
                                      payload: second_payload)

    expect(response.code).to be 403
  end

  it 'responds with a 403 when not authorised', tms: '404' do
    response = Booking.update_booking(id: BaseSteps.booking_id,
                                      payload: second_payload,
                                      token: BaseSteps.auth_response_token(username: 'nmida', password: '321drowssap'))

    expect(response.code).to be 403
  end

  it 'responds with a 405 when attempting to update a booking that does not exist', tms: '405' do
    response = Booking.update_booking(id: 1_234_567_890,
                                      payload: second_payload,
                                      token: BaseSteps.auth_response_token)

    expect(response.code).to be 405
  end
end
