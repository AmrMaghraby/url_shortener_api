Rails.application.routes.draw do
  post "/encode", to: "api/urls#encode"
  post "/decode", to: "api/urls#decode"

  get "/:code", to: "redirects#show"
end
