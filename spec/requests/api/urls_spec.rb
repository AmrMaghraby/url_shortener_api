# spec/requests/urls_spec.rb
require "rails_helper"

RSpec.describe "URLs API", type: :request do
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  end

  describe "POST /encode" do
    context "with valid input" do
      it "encodes url successfully" do
        post "/encode",
             params: { url: "https://example.com" }.to_json,
             headers: headers

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body["data"]["short_url"]).to be_a(String)
        expect(body["data"]["code"]).to be_present
      end
    end

    context "with invalid input" do
      it "returns error when url is missing" do
        post "/encode",
             params: {}.to_json,
             headers: headers

        expect(response).to have_http_status(:bad_request)

        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end

      it "returns error when url is empty" do
        post "/encode",
             params: { url: "" }.to_json,
             headers: headers

        expect(response).to have_http_status(:bad_request)
      end

      it "returns error when url is whitespace" do
        post "/encode",
             params: { url: "   " }.to_json,
             headers: headers

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "POST /decode" do
    context "with valid input" do
      it "decodes short url successfully" do
        short_record = UrlEncoder.new(
          original_url: "https://example.com"
        ).call

        short_url = "http://short.ly/#{short_record.code}"

        post "/decode",
             params: { short_url: short_url }.to_json,
             headers: headers

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body["data"]["original_url"]).to eq("https://example.com")
      end
    end

    context "with invalid input" do
      it "returns error when short_url is missing" do
        post "/decode",
             params: {}.to_json,
             headers: headers

        expect(response).to have_http_status(:bad_request)
      end

      it "returns error when short_url is empty" do
        post "/decode",
             params: { short_url: "" }.to_json,
             headers: headers

        expect(response).to have_http_status(:bad_request)
      end

      it "returns not found when code does not exist" do
        post "/decode",
             params: { short_url: "http://short.ly/unknown123" }.to_json,
             headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
