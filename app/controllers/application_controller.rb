class ApplicationController < ActionController::API
  class InvalidParameter < StandardError; end
  include ActionController::Serialization
  include CanCan::ControllerAdditions
  ActionController::Parameters.permit_all_parameters = true

  rescue_from(
    ActionController::ParameterMissing,
    with: :rescue_from_param_missing,
  )

  rescue_from(
    InvalidParameter,
    with: :rescue_from_invalid_parameter,
  )

  rescue_from(
    CanCan::AccessDenied,
    with: :rescue_from_unauthorised_cancan_access
  )

  def rescue_from_param_missing(error)
    render_error(
      status: :bad_request,
      code: "param_missing",
      detail: error.message
    )
  end

  def rescue_from_invalid_parameter(error)
    render_error(
      status: :bad_request,
      code: "invalid_parameter",
      detail: error.message
    )
  end

  def rescue_from_unauthorised_cancan_access(error)
    render_error(
      status: :unauthorized,
      code: "access_denied",
      detail: error.message
    )
  end

  def render_error(status:, code:, detail: nil)
    error = {
      code: code,
      detail: detail,
    }

    render status: status, json: { errors: [error] }
  end

  def render_activemodel_validations(errors)
    errors = errors.full_messages.map do |error|
      {
        code: "validation_error",
        detail: error
      }
    end

    render(
      json: { errors: errors },
      status: :unprocessable_entity
    )
  end
end
