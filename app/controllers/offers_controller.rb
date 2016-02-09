# Serve Offers requests
class OffersController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js do
        offer = Offer.new(offer_params)
        @offers = JSON.parse(offer.fetch.body)['offers']
      end
    end
  end

  private

  def offer_params
    params[:offer].permit(:uid, :pub0, :page) if params[:offer]
  end
end
