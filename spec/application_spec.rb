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
    before(:each) do
      Moneta::File.new(:path => File.join(File.dirname(__FILE__), '..', "questionnaires")).clear
    end

    it "should render first part of form" do
      get '/first_part/test'
      last_response.should be_ok
    end

    it "should save first part parameters" do
      post '/save_first/test', 'questionnaire' => {'frequency' => 'none'}
      last_response.should be_redirect
    end

    it "should render second part of form" do
      get '/second_part/test'
      last_response.should be_ok
    end

    it "should save second part parameters" do
      post '/save_second/test', 'questionnaire' => {'relation' => 'none'}
      last_response.should be_redirect
    end

    it "should render thanks page" do
      get '/thanks/test'
      last_response.should be_ok
    end

    it "should save final part parameters" do
      post '/save_final/test', 'questionnaire' => {'email' => 'none'}
      last_response.should be_redirect
    end

    it "should show printable version of what was filled" do
      get '/print/test'
      last_response.should be_ok
    end
  end
end


