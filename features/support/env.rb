require 'spec/spec_helper'
require File.join(File.dirname(__FILE__), '..', '..', 'app', 'application')

require "rubygems"
require "bundler"
Bundler.setup
require 'webrat'


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
