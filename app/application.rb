require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env
require 'moneta/file'
require 'digest/sha1'

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
      @uid = generate_uid
      haml :index
    end

    get '/first_part/:uid' do
      haml :first_part
    end

    post '/save_first/:uid' do
      save_to_cache(params[:uid], params['questionnaire'])
      redirect "/second_part/#{params[:uid]}"
    end

    get '/second_part/:uid' do
      haml :second_part
    end

    post '/save_second/:uid' do
      save_to_cache(params[:uid], params['questionnaire'])
      redirect "/thanks/#{params[:uid]}"
    end

    get '/thanks/:uid' do
      haml :thanks
    end

    post '/save_final/:uid' do
      save_to_cache(params[:uid], params['questionnaire'])
      redirect '/'
    end

    get '/print/:uid' do 
      @questionnaire = @@cache[params[:uid]]
      haml :print
    end

    private
    # generates uniq code
    def generate_uid
      Digest::SHA1.hexdigest(Time.now.to_s).to_s
    end

    # saves from session to cache
    def save_to_cache(uid, questionnaire)
      # needed cause is bad to dump Hash with default proc
      if @@cache.key?(uid)
        questionnaire = @@cache[uid].merge(questionnaire) 
      else
        questionnaire = {}.merge(questionnaire)
      end
      @@cache[uid] = questionnaire
    end
  end
end
