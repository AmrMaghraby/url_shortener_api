# spec/services/url_decoder_spec.rb
require "rails_helper"

RSpec.describe UrlDecoder do
  let(:original_url) { "https://example.com" }
  let(:code) { "abc123" }
  let(:short_url_string) { "http://short.ly/#{code}" }

  before do
    ShortUrl.create!(
      original_url: original_url,
      code: code
    )
  end

  describe "#call" do
    context "with valid short url" do
      it "returns the original url" do
        decoded = described_class.new(
          short_url: short_url_string
        ).call

        expect(decoded).to eq(original_url)
      end
    end

    context "with unknown short code" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          described_class.new(
            short_url: "http://short.ly/unknown"
          ).call
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "with invalid short url format" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          described_class.new(
            short_url: "not-a-url-at-all"
          ).call
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "with nil short_url" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          described_class.new(short_url: nil).call
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "with empty short_url" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          described_class.new(short_url: "").call
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
