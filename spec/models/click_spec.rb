# spec/models/click_spec.rb
require "rails_helper"

RSpec.describe Click, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:short_url) }
  end

  describe "validations" do
    context "when short_url is missing" do
      it "is invalid without a short_url" do
        click = Click.new(ip_address: "127.0.0.1")

        expect(click).not_to be_valid
        expect(click.errors[:short_url]).to be_present
      end

      it "is invalid when short_url is nil" do
        click = Click.new(short_url: nil, ip_address: "127.0.0.1")

        expect(click).not_to be_valid
      end
    end

    context "when ip_address is invalid" do
      it "is invalid without an ip_address" do
        click = Click.new(short_url: build(:short_url))

        expect(click).not_to be_valid
        expect(click.errors[:ip_address]).to be_present
      end

      it "is invalid with empty ip_address" do
        click = Click.new(
          short_url: build(:short_url),
          ip_address: ""
        )

        expect(click).not_to be_valid
      end

      it "is invalid with whitespace ip_address" do
        click = Click.new(
          short_url: build(:short_url),
          ip_address: "   "
        )

        expect(click).not_to be_valid
      end
    end
  end

  describe "valid state" do
    it "is valid with short_url and ip_address" do
      click = Click.new(
        short_url: build(:short_url),
        ip_address: "127.0.0.1"
      )

      expect(click).to be_valid
    end
  end
end
