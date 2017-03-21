Apipie.configure do |config|
  config.app_name                = "Team USR Backend"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.markup = Apipie::Markup::Markdown.new
  config.validate = false
end
