# spec/services/url_encoder_spec.rb
require "rails_helper"

RSpec.describe UrlEncoder do
  let(:url) { "https://example.com" }

  describe "#call" do
    context "with valid original_url" do
      it "creates a short url record" do
        short = described_class.new(original_url: url).call

        expect(short).to be_present
        expect(short).to be_a(ShortUrl)
        expect(short.original_url).to eq(url)
        expect(short.code).to be_present
      end

      it "returns the same short url for the same input (idempotent)" do
        first = described_class.new(original_url: url).call
        second = described_class.new(original_url: url).call

        expect(first).to eq(second)
      end
    end

    context "with invalid input" do
      it "raises RecordInvalid when original_url is nil" do
        expect {
          described_class.new(original_url: nil).call
        }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "raises RecordInvalid when original_url is empty" do
        expect {
          described_class.new(original_url: "").call
        }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "raises RecordInvalid when original_url is whitespace" do
        expect {
          described_class.new(original_url: "   ").call
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
