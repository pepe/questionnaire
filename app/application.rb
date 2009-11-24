require 'sinatra/base'
require 'haml'

module Questionnaire
  class Application < Sinatra::Base
    enable :static, :sessions

    get '/' do
      haml :index
    end
  end
end
