require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env :test

require 'spec/interop/test'

require 'app/lib/database'

Questionnaire::Database.environment = :test

# return app for rack test
def app
  @app ||= Sinatra.new Questionnaire::Application
end
