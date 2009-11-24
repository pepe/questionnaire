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

  describe "Questionnaire" do
    it "should render first part of form" do
      get '/first_part'
      last_response.should be_ok
    end

    it "should save first part parameters" do
      post '/save_first', 'questionnaire' => {'frequency' => 'none'}
      last_response.should be_redirect
      session['questionnaire']['frequency'].should == 'none'
    end

    it "should render second part of form" do
      get '/second_part'
      last_response.should be_ok
    end

    it "should save second part parameters" do
      post '/save_second', 'questionnaire' => {'relation' => 'none'}
      last_response.should be_redirect
      session['questionnaire']['relation'].should == 'none'
    end

    it "should render thanks page" do
      get '/thanks'
      last_response.should be_ok
    end

    it "should save final part parameters" do
      post '/save_final', 'questionnaire' => {'email' => 'none'}
      last_response.should be_redirect
      session['questionnaire']['email'].should == 'none'
    end
  end
end


