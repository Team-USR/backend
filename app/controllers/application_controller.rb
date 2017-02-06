class ApplicationController < ActionController::API
  include ActionController::Serialization
  # include ActionDispatch::Request
  ActionController::Parameters.permit_all_parameters = true
end
