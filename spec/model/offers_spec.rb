require 'rails_helper'

describe Offer do
  describe 'HTTParty config' do
    subject { Offer }
    let(:base_uri) { 'http://api.fyber.com/feed/v1/offers.json' }
    its(:base_uri) { is_expected.to eql base_uri }
    its(:format) { is_expected.to eql :json }
  end

  describe 'search' do
    subject { Offer.new(uid: 'player1', pub0: 'abc', page: 1) }
    let(:appid) { '157' }
    let(:ip) { '109.235.143.113' }
    let(:locale) { 'de' }
    let(:device_id) { '2b6f0cc904d137be2e1730235f5664094b83' }
    let(:api_key) { 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f' }
    let(:hashkey) do
      Digest::SHA1.hexdigest('appid=157'\
        '&device_id=2b6f0cc904d137be2e1730235f5664094b83' \
        '&ip=109.235.143.113&locale=de&page=1&pub0=abc' \
        '&timestamp=1451586600&uid=player1' \
        '&b07a12df7d52e6c118e5d47d3f9e60135b109a1f')
    end

    before do
      allow(subject).to receive(:appid) { appid }
      allow(subject).to receive(:ip) { ip }
      allow(subject).to receive(:locale) { locale }
      allow(subject).to receive(:device_id) { device_id }
      allow(subject).to receive(:api_key) { api_key }
      allow(Time).to receive(:now) { Time.new('2016-01-01') }
    end

    describe 'initialize with params' do
      subject { Offer.new(uid: 'player1', pub0: 'abc', page: 1) }
      it { expect { subject }.not_to raise_error }
    end

    describe '#hashkey' do
      its(:hashkey) { is_expected.to eql hashkey }
    end

    describe '#valid?' do
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
        allow(subject).to receive(:response) { response }
      end

      it 'calls api with given parameters and validate signature' do
        expect(Offer).to receive(:get)
          .with('/', query: subject.parameters_with_hashkey)
        expect(subject).to receive(:valid?) { true }
        subject.fetch
      end

      context 'valid' do
        let(:response) do
          double('response',
                 body: response_body,
                 headers: {
                   'X-Sponsorpay-Response-Signature' =>
                     '3d4a26391c45deb236efa9d901a92a15b9315770'
                 })
        end

        it { is_expected.to be_valid }
      end

      context 'invalid' do
        let(:response) do
          double('response',
                 body: response_body,
                 headers: { 'X-Sponsorpay-Response-Signature' => 'abc' })
        end

        it { is_expected.not_to be_valid }
      end
    end

    describe '#fetch' do
      context 'valid' do
        before { allow(subject).to receive(:valid?) { true } }
        it 'returns an HTTParty response' do
          expect(subject.fetch.class).to eql HTTParty::Response
        end
      end

      context 'invalid' do
        before { allow(subject).to receive(:valid?) { false } }
        it 'raises a InvalidSignatureError' do
          expect { subject.fetch }.to raise_error 'InvalidSignatureError'
        end
      end
    end
  end
end
