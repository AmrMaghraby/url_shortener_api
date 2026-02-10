# spec/requests/redirects_spec.rb
require "rails_helper"

RSpec.describe "Redirects", type: :request do
  describe "GET /:code" do
    context "when short url exists" do
      it "redirects to original_url and tracks click" do
        short = ShortUrl.create!(
          original_url: "https://example.com",
          code: "abc123"
        )

        expect {
          get "/abc123"
        }.to change { short.clicks.count }.by(1)

        expect(response).to redirect_to("https://example.com")
        expect(response).to have_http_status(:found) # 302
      end
    end

    context "when code does not exist" do
      it "returns 404" do
        expect {
          get "/unknown"
        }.not_to change { Click.count }

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when short url was deleted" do
      it "returns 404 and does not track click" do
        short = ShortUrl.create!(
          original_url: "https://example.com",
          code: "gone123"
        )

        short.destroy

        expect {
          get "/gone123"
        }.not_to change { Click.count }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
