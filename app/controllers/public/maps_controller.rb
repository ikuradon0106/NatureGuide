class Public::MapsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'


  def show
    # 
    @taxon_key = params[:taxon_key]

    if @taxon_key.present?
      url = URI("https://api.gbif.org/v1/occurrence/search?taxonKey=#{@taxon_key}&limit=100")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      @occurrences = data["results"]
    else
      @occurrences = []
    end
  end

  def fetch_map_data
    taxon_key = params[:taxon_key]

    if taxon_key.present?
      url = URI("https://api.gbif.org/v1/occurrence/search?taxonKey=#{taxon_key}&limit=100")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)
      occurrences = data["results"]
      render json: { occurrences: occurrences }
    else
      render json: { error: "taxon_keyがありません" }, status: :bad_request
    end
  end
end
