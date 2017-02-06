class ApplicationController < ActionController::API
  include ActionController::Serialization
  ActionController::Parameters.permit_all_parameters = true
end
