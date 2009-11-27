require 'spec/spec_helper'

require File.join(File.dirname(__FILE__), '..', 'app', 'application')

Test::Unit::TestCase.send :include, Rack::Test::Methods
describe Questionnaire::Application do
  include Questionnaire
  
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
      session['code'].should_not be_empty
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

    it "should show printable version of what was filled" do
      get '/print/aaaaa'
      last_response.should be_ok
    end
  end
end


