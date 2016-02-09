# Offer class is to get offers from fyber API.
# It includes HTTParty to interact HTTP URL.
class Offer
  include HTTParty
  base_uri 'http://api.fyber.com/feed/v1/offers.json'
  format :json
  attr_reader :response

  def initialize(params)
    @uid = params[:uid]
    @pub0 = params[:pub0]
    @page = params[:page]
  end

  def hashkey
    query_string = parameters.map { |k, v| "#{k}=#{v}&" }.sort.join
    digest(query_string)
  end

  def fetch
    @response = self.class.get('/', query: parameters_with_hashkey)
    fail 'InvalidSignatureError' unless valid?
    @response
  end

  def valid?
    response.headers['X-Sponsorpay-Response-Signature'] == digest(response.body)
  end

  def parameters_with_hashkey
    parameters.merge(hashkey: hashkey)
  end

  def parameters
    @parameters = {
      uid: @uid,
      pub0: @pub0,
      page: @page,
      appid: appid,
      ip: ip,
      locale: locale,
      device_id: device_id,
      timestamp: Time.now.to_i
    }
  end

  private

  def digest(string)
    Digest::SHA1.hexdigest(string + api_key)
  end

  def api_key
    Rails.application.secrets.fyber['api_key']
  end

  def appid
    Rails.application.secrets.fyber['appid']
  end

  def ip
    Rails.application.secrets.fyber['ip']
  end

  def locale
    Rails.application.secrets.fyber['locale']
  end

  def device_id
    Rails.application.secrets.fyber['device_id']
  end
end
