require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env
require 'app/lib/database'
require 'app/model/sheet'

module Questionnaire
  QUESTIONNAIRE_ROOT = File.join(File.expand_path(File.dirname(__FILE__)), '..') unless defined?(QUESTIONNAIRE_ROOT)
  class Application < Sinatra::Base
    enable :static, :sessions
    set :root, QUESTIONNAIRE_ROOT
    set :public, File.join(QUESTIONNAIRE_ROOT, '/public')

    helpers do
      # returns five reversed options 
      def five_options
        (1..5).map do |i|
          "<option>%i</option>" % i
        end.reverse.join(' ')
      end

      # links to questionnaire detail
      def link_to(questionnaire)
        "<a href='/print/%s'>%s</a>" % ([questionnaire['_id']] * 2)
      end
    end

    get '/' do
      sheet = Sheet.start_new
      sheet.save
      @uid = sheet['_id']
      ['_id']
      haml :index
    end

    get '/first_part/:uid' do
      haml :first_part
    end

    post '/save_first/:uid' do
      @sheet = Sheet.get(params['uid'])
      @sheet.update_attributes(params['questionnaire'])
      redirect "/second_part/#{params[:uid]}"
    end

    get '/second_part/:uid' do
      haml :second_part
    end

    post '/save_second/:uid' do
      @sheet = Sheet.get(params['uid'])
      @sheet.finish
      @sheet.update_attributes(params['questionnaire'])
      redirect "/thanks/#{params[:uid]}"
    end

    get '/thanks/:uid' do
      haml :thanks
    end

    post '/save_final/:uid' do
      @sheet = Sheet.get(params['uid'])
      @sheet.update_attributes(params['questionnaire'])
      redirect '/'
    end

    get '/print/:uid' do 
      @questionnaire = Sheet.get(params[:uid])
      haml :print
    end

    get '/list' do
      @questionnaires = Sheet.all
      haml :list
    end
  end
end
