module Api
  class UrlsController < ApplicationController
    def encode
      short_url = UrlEncoder.new(
        original_url: params.require(:url)
      ).call

      render json: {
        data: {
          id: short_url.id,
          original_url: short_url.original_url,
          code: short_url.code,
          short_url: "#{ENV.fetch("SHORT_BASE_URL", "http://short.ly")}/#{short_url.code}",
          clicks_count: short_url.clicks_count,
          created_at: short_url.created_at
        }
      }
    end

    def decode
      short_url = params.require(:short_url)
    
      original = UrlDecoder.new(
        short_url: short_url
      ).call
    
      render json: {
        data: {
          original_url: original
        }
      }
    end
    
  end
end
