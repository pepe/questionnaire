require 'spec/expectations'
require 'spec/mocks'
require 'rack/test'
require 'webrat'
require 'haml'
require 'rufus-tokyo'

require 'app/application'

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

