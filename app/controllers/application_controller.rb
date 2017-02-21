class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Knock::Authenticable
  ActionController::Parameters.permit_all_parameters = true
end
