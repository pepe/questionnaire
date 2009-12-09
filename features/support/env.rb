require 'spec/spec_helper'
require File.join(File.dirname(__FILE__), '..', '..', 'app', 'application')

Bundler.require_env :test

Questionnaire::Application.set :environment, :development
Webrat.configure do |config|
  config.mode = :rack
end
World do
  def app
    @app = Rack::Builder.new do
      use Rack::Session::Cookie
      run Questionnaire::Application
    end
  end
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
end
