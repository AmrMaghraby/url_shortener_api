# spec/models/short_url_spec.rb
require "rails_helper"

RSpec.describe ShortUrl, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:clicks).dependent(:destroy) }
  end

  describe "validations" do
    context "when original_url is invalid" do
      it "is invalid without original_url" do
        short_url = ShortUrl.new(code: "abc123")

        expect(short_url).not_to be_valid
        expect(short_url.errors[:original_url]).to be_present
      end

      it "is invalid with empty original_url" do
        short_url = ShortUrl.new(
          original_url: "",
          code: "abc123"
        )

        expect(short_url).not_to be_valid
      end

      it "is invalid with whitespace original_url" do
        short_url = ShortUrl.new(
          original_url: "   ",
          code: "abc123"
        )

        expect(short_url).not_to be_valid
      end
    end

    context "when code is invalid" do
      it "is invalid without code" do
        short_url = ShortUrl.new(original_url: "https://example.com")

        expect(short_url).not_to be_valid
        expect(short_url.errors[:code]).to be_present
      end

      it "is invalid with empty code" do
        short_url = ShortUrl.new(
          original_url: "https://example.com",
          code: ""
        )

        expect(short_url).not_to be_valid
      end

      it "is invalid with whitespace code" do
        short_url = ShortUrl.new(
          original_url: "https://example.com",
          code: "   "
        )

        expect(short_url).not_to be_valid
      end
    end

    context "when code is not unique" do
      it "is invalid with duplicate code" do
        ShortUrl.create!(
          original_url: "https://a.com",
          code: "dup123"
        )

        duplicate = ShortUrl.new(
          original_url: "https://b.com",
          code: "dup123"
        )

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:code]).to be_present
      end
    end
  end

  describe "valid state" do
    it "is valid with original_url and unique code" do
      short_url = ShortUrl.new(
        original_url: "https://example.com",
        code: "abc123"
      )

      expect(short_url).to be_valid
    end
  end
end
