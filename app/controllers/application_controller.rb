class ApplicationController < ActionController::API
  KNOWN_ERRORS = [
    ActionController::ParameterMissing,
    ActiveRecord::RecordNotFound,
    ActiveRecord::RecordInvalid
  ].freeze

  rescue_from ActionController::ParameterMissing do |e|
    render_error(
      code: "invalid_request",
      message: "Missing required parameter: #{e.param}",
      status: :bad_request
    )
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_error(
      code: "not_found",
      message: "Resource not found",
      status: :not_found
    )
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render_error(
      code: "validation_error",
      message: e.record.errors.full_messages,
      status: :unprocessable_entity
    )
  end

  unless Rails.env.development? || Rails.env.test?
    rescue_from StandardError do |e|
      raise e if KNOWN_ERRORS.any? { |k| e.is_a?(k) }

      Rails.logger.error "[#{e.class}] #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      render_error(
        code: "internal_error",
        message: "Something went wrong",
        status: :internal_server_error
      )
    end
  end

  private

  def render_error(code:, message:, status:)
    render json: {
      error: {
        code: code,
        message: message
      }
    }, status: status
  end
end
