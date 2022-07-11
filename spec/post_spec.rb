include Authorise
include BaseSteps
include Booking

describe '[POST]' do
  describe '/booking Restful-booker' do
    let(:payload) { BaseSteps.generate_payload }

    let(:response) { Booking.create_booking(payload.to_json) }

    it 'responds with the created booking and assigned booking id', tms: '301' do
      expect(response.code).to be 200
      expect(response.body).to include 'bookingid'
      expect(response.body).to include payload.to_json
    end

    it 'responds with first name of existing booking', tms: '302' do
      expect(JSON.parse(response.body)['booking']['firstname']).to eq payload.firstname
    end

    it 'responds with last name of existing booking', tms: '303' do
      expect(JSON.parse(response.body)['booking']['lastname']).to eq payload.lastname
    end

    it 'responds with total price of existing booking', tms: '304' do
      expect(JSON.parse(response.body)['booking']['totalprice']).to eq payload.totalprice
    end

    it 'responds with deposit paid of existing booking', tms: '305' do
      expect(JSON.parse(response.body)['booking']['depositpaid']).to be payload.depositpaid
    end

    it 'responds with check-in date of existing booking', tms: '306' do
      expect(JSON.parse(response.body)['booking']['bookingdates']['checkin']).to eq payload.checkin
    end

    it 'responds with check-out date of existing booking', tms: '307' do
      expect(JSON.parse(response.body)['booking']['bookingdates']['checkout']).to eq payload.checkout
    end

    it 'responds with additional needs of existing booking', tms: '308' do
      expect(JSON.parse(response.body)['booking']['additionalneeds']).to eq payload.additionalneeds
    end

    it 'responds with a 500 error when a bad payload is sent', tms: '309' do
      bad_payload = { lastname: 'Brown', totalprice: 111, depositpaid: true, additionalneeds: 'Breakfast' }
      response = Booking.create_booking(bad_payload.to_json)

      expect(response.code).to be 500
    end

    it 'responds with the correct assigned booking id when multiple payloads are sent', tms: '310' do
      init_booking_id = BaseSteps.booking_id

      expect(BaseSteps.booking_id).to eq init_booking_id + 1
    end

    it 'responds with a 200 when a payload with extra parameter is sent', tms: '311' do
      payload = BaseSteps.generate_payload extra_parameter: true
      response = Booking.create_booking(payload.to_json_with_extra_parameter)

      expect(response.code).to be 200
    end

    it 'responds with a 418 when using a bad accept header', tms: '312' do
      response = Booking.create_booking(payload.to_json, accept: 'application/ogg')

      expect(response.code).to be 418
    end
  end

  describe '/auth Restful-booker' do
    it 'responds with a 200 and a token to use when POSTing a valid credential', tms: '313' do
      response = BaseSteps.auth_response

      expect(response.code).to be 200
      expect(response.body).to include('token').and match(/[a-zA-Z\d]{15,}/)
    end

    it 'responds with a 200 and a message informing of login failed when POSTing invalid credential', tms: '314' do
      response = BaseSteps.auth_response username: 'nimda', password: '321drowssap'

      expect(response.code).to be 200
      expect(response.body).to include('reason').and include('Bad credentials')
    end
  end
end
