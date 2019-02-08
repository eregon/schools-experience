require 'rails_helper'

describe Candidates::Registrations::AddressesController, type: :request do
  context '#new' do
    before do
      get '/candidates/schools/URN/registrations/address/new'
    end

    it 'responds with 200' do
      expect(response.status).to eq 200
    end

    it 'renders the new form' do
      expect(response.body).to render_template :new
    end
  end

  context '#create' do
    before do
      post '/candidates/schools/URN/registrations/address',
        params: address_params
    end

    context 'invalid' do
      let :address_params do
        {
          candidates_registrations_address: {
            building: 'Test house',
            street: 'Test street',
            town_or_city: 'Test Town',
            county: 'Testshire',
            postcode: 'TE57 1NG'
          }
        }
      end

      it 'rerenders the new template' do
        expect(response).to render_template :new
      end
    end

    context 'valid' do
      let :address_params do
        {
          candidates_registrations_address: {
            building: 'Test house',
            street: 'Test street',
            town_or_city: 'Test Town',
            county: 'Testshire',
            postcode: 'TE57 1NG',
            phone: '01234567890',
          }
        }
      end

      it 'stores the address details in the session' do
        expect(session["registration"]["candidates_registrations_address"]).to eq(
          "building" => 'Test house',
          "street" => 'Test street',
          "town_or_city" => 'Test Town',
          "county" => 'Testshire',
          "postcode" => 'TE57 1NG',
          "phone" => '01234567890'
        )
      end

      it 'redirects to the next step' do
        expect(response).to redirect_to '/candidates/schools/URN/registrations/subject_preference/new'
      end
    end
  end
end