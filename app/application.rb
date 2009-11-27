require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env
require 'moneta/file'

module Questionnaire
  class Application < Sinatra::Base
    enable :static, :sessions, :cookies

    helpers do
      # returns five options 
      def five_options
        (1..5).map do |i|
          "<option>%i</option>" % i
        end.reverse.join(' ')
      end
    end

    get '/' do
      haml :index
    end

    get '/first_part' do
      haml :first_part
    end

    post '/save_first' do
      session['questionnaire'] ||= {}
      session['questionnaire'].merge! params['questionnaire']
      redirect '/second_part'
    end

    get '/second_part' do
      haml :second_part
    end

    post '/save_second' do
      session['questionnaire'] ||= {}
      session['questionnaire'].merge! params['questionnaire']
      redirect '/thanks'
    end

    get '/thanks' do
      haml :thanks
    end

    post '/save_final' do
      session['questionnaire'] ||= {}
      session['questionnaire'].merge! params['questionnaire']
      redirect '/'
    end
  end
end
