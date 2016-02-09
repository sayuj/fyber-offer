require 'rails_helper'

describe 'Offers Index Page' do
  describe 'search form' do
    it 'has a form to accept uid, pub0 and page' do
      visit offers_path
      expect(page).to have_css('form')
      expect(page).to have_content('UID')
      expect(page).to have_content('Pub0')
      expect(page).to have_content('Page')
      expect(page).to have_content('Search')
    end
  end

  context 'has offers' do
    let(:response_body) do
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

    it 'fetches offers', js: true do
      visit offers_path
      fill_in 'offer[uid]', with: 'player1'
      fill_in 'offer[pub0]', with: 'abc'
      fill_in 'offer[page]', with: '1'
      click_button 'Search'
      expect(page).to have_css('.offer', count: 1)
      expect(page).to have_content('William Hill Poker - Deposit')
      expect(page).to have_content('2047127')
    end
  end
end
