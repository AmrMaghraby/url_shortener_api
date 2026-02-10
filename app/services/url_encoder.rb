class UrlEncoder
    MAX_RETRIES = 5
  
    def initialize(original_url:)
      @original_url = original_url
    end
  
    def call
      # Idempotent behavior: if URL already exists, return it.
      existing = ShortUrl.find_by(original_url: @original_url)
      return existing if existing
  
      tries = 0
  
      begin
        tries += 1
        code = CodeGenerator.generate
  
        # Create directly, let DB unique index be final guard.
        ShortUrl.create!(original_url: @original_url, code: code)
      rescue ActiveRecord::RecordNotUnique
        # If collision happens, retry a few times.
        raise if tries >= MAX_RETRIES
        retry
      end
    end
  end
  