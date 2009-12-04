require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env

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
      @@cache ||= CouchRest.database!("http://127.0.0.1:5984/questionnaires")
    end

    get '/' do
      @uid = save_to_cache({'start' => Time.now.strftime('%D %T')})
      haml :index
    end

    get '/first_part/:uid' do
      haml :first_part
    end

    post '/save_first/:uid' do
      save_to_cache(params['questionnaire'], params[:uid])
      redirect "/second_part/#{params[:uid]}"
    end

    get '/second_part/:uid' do
      haml :second_part
    end

    post '/save_second/:uid' do
      questionnaire = params['questionnaire'].merge(
        {'finish' => Time.now.strftime('%D %T')})
      save_to_cache(questionnaire, params[:uid])
      redirect "/thanks/#{params[:uid]}"
    end

    get '/thanks/:uid' do
      haml :thanks
    end

    post '/save_final/:uid' do
      save_to_cache(params['questionnaire'], params[:uid])
      redirect '/'
    end

    get '/print/:uid' do 
      @questionnaire = @@cache.get(params[:uid])
      haml :print
    end

    private
    # generates uniq code
    def generate_uid
      Digest::SHA1.hexdigest(Time.now.to_s).to_s
    end

    # saves from session to cache
    # when uid is nil returns new
    def save_to_cache(questionnaire, uid = nil)
      # needed cause is bad to dump Hash with default proc
      if uid
        questionnaire = @@cache.get(uid).merge(questionnaire) 
      else
        questionnaire = {}.merge(questionnaire)
      end
      @@cache.save_doc(questionnaire)['id']
    end
  end
end
