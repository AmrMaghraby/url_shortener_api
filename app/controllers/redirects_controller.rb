class RedirectsController < ApplicationController
  def show
    short = ShortUrl.find_by!(code: params[:code])

    short.clicks.create!(
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      clicked_at: Time.current
    )

    redirect_to short.original_url, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    render plain: "Not found", status: 404
  end
end
