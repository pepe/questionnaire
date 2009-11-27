require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env :test

require 'spec/interop/test'

# return app for rack test
def app
  @app ||= Sinatra.new Questionnaire::Application
end

def session
  last_request.env['rack.session']
end

def cookies
  last_request.cookies
end
