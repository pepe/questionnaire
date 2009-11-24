require 'rubygems'
require 'rack/test'
require 'spec'
require 'spec/interop/test'

require 'app/application'

Test::Unit::TestCase.send :include, Rack::Test::Methods
describe Questionnaire::Application do
  include Questionnaire
  
  # return app for rack test
  def app
    Questionnaire::Application.new
  end

  def session
    last_request.env['rack.session']
  end

  describe "Home page" do
    it "should render page with basic informations" do
      get '/'
      last_response.should be_ok
    end
  end
end


