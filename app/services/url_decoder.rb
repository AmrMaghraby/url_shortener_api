class UrlDecoder
  def initialize(short_url:)
    @short_url = short_url.to_s
  end

  def call
    code = extract_code
    ShortUrl.find_by!(code: code).original_url
  end

  private

  def extract_code
    URI.parse(@short_url).path.delete_prefix("/")
  end
end
