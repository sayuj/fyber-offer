require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:response_body)do
    {
      code: 'OK',
      message: 'Ok',
      count: 30,
      pages: 2,
      information: {
        app_name: 'Demo iframe for publisher - do not touch',
        appid: 157,
        virtual_currency: 'Coins',
        virtual_currency_sale_enabled: false,
        country: 'DE',
        language: 'DE',
        support_url: 'http://offer.fyber.com/mobile/support?appid=157&client=api&uid=player1'
      },
      offers: [
        {
          title: 'William Hill Poker - Deposit',
          offer_id: 772_941,
          teaser: 'Signup with a new account.',
          required_actions: 'Signup with a new account.',
          link: 'http://offer.fyber.com/mobile?impression=true&appid=157&uid=player1&client=api&platform=web&appname=Demo+iframe+for+publisher+-+do+not+touch&traffic_source=offer_api&country_code=DE&pubid=249&ip=109.235.143.113&pub0=1&device_id=2b6f0cc904d137be2e1730235f5664094b83&flash_cookie=e5c83a44cfd62ae87bc18089eddbf366&ad_id=772941&ad_format=offer&sig=eb91bbcec69071df17a410b47546e6566755a6d7',
          offer_types: [
            {
              offer_type_id: 103,
              readable: 'Einkaufen'
            },
            {
              offer_type_id: 106,
              readable: 'Spiele'
            },
            {
              offer_type_id: 109,
              readable: 'Spiele'
            }
          ],
          payout: 204_712_7,
          time_to_payout: {
            amount: 3600,
            readable: '1 hour'
          },
          thumbnail: {
            lowres: 'http://cdn3.sponsorpay.com/assets/60553/william-hill-poker-logo_original.png',
            hires: 'http://cdn3.sponsorpay.com/assets/60553/william-hill-poker-logo_original.png'
          },
          store_id: ''
        }
      ]
    }.to_json
  end

  before do
    response = double('response', body: response_body)
    allow_any_instance_of(Offer).to receive(:fetch) { response }
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'fetch offer and respond with success' do
      expect_any_instance_of(Offer).to receive(:fetch)
      xhr :get, :index, offer: { uid: 'p1' }, format: :js
      expect(response).to have_http_status :success
    end
  end
end
