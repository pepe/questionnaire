require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env
require 'moneta/file'

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
    end

    before do
      @@cache ||= Moneta::File.new(:path => File.join(File.dirname(__FILE__), '..', "questionnaires"))
    end

    get '/' do
      haml :index
    end

    get '/first_part' do
      haml :first_part
    end

    post '/save_first' do
      save_to_session(params['questionnaire'])
      redirect '/second_part'
    end

    get '/second_part' do
      haml :second_part
    end

    post '/save_second' do
      save_to_cache(params['questionnaire'])
      redirect '/thanks'
    end

    get '/thanks' do
      @code = session['code']
      haml :thanks
    end

    post '/save_final' do
      save_to_cache(params['questionnaire'])
      redirect '/'
    end

    get %r{\/print\/([0-9a-f]+)} do |id|
      @questionnaire = @@cache[id]
      haml :print
    end

    private
    # saves questionnaire to session
    def save_to_session(questionnaire)
      session['questionnaire'] ||= {}
      session['questionnaire'].merge! questionnaire
    end

    # saves from session to cache
    def save_to_cache(questionnaire)
      save_to_session(questionnaire)
      session['code'] ||= "Q%02x" % session['questionnaire'].hash
      @@cache[session['code']] = session['questionnaire']
    end
  end
end
