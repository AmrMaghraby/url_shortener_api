FactoryBot.define do
    factory :short_url do
      original_url { "https://example.com" }
      sequence(:code) { |n| "abc#{n}" }
    end
  end
  