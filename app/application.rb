require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env
require 'app/lib/database'
require 'app/model/sheet'

module Questionnaire
  QUESTIONNAIRE_ROOT = File.join(File.expand_path(File.dirname(__FILE__)), '..') unless defined?(QUESTIONNAIRE_ROOT)
  class Application < Sinatra::Base
    enable :static, :sessions
    set :root, QUESTIONNAIRE_ROOT
    set :public, File.join(QUESTIONNAIRE_ROOT, 'public')
    set :views, File.join(QUESTIONNAIRE_ROOT, 'app', 'views')

    helpers do

      # returns occurence and percents for stats
      def occurence_and_percents(stat)
        res = ''
        @stats[stat].each_pair {|key, value|
           unless key == 'all'
             res << "<li>%s: %s (%s%%)</li>\n" % 
               [key, value, (value/@stats[stat]['all'].to_f) *100]
           end
        }
        return res
      end
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
      @questionnaires = Sheet.by_finished
      haml :list
    end

    get '/stats' do
      @stats = {:frequency => Questionnaire::Sheet.sumas_for(:frequency),
                :purpose_relaxation => Questionnaire::Sheet.sumas_for(:purpose_relaxation),
                :purpose_fuel => Questionnaire::Sheet.sumas_for(:purpose_fuel),
                :purpose_gathering => Questionnaire::Sheet.sumas_for(:purpose_gathering),
                :purpose_hobbitry => Questionnaire::Sheet.sumas_for(:purpose_hobbitry),
                :important_wood => Questionnaire::Sheet.sumas_for(:important_wood),
                :important_nature => Questionnaire::Sheet.sumas_for(:important_nature),
                :important_ground => Questionnaire::Sheet.sumas_for(:important_ground),
                :important_climate => Questionnaire::Sheet.sumas_for(:important_climate),
                :important_gathering => Questionnaire::Sheet.sumas_for(:important_gathering),
                :important_health => Questionnaire::Sheet.sumas_for(:important_health),
                :important_water => Questionnaire::Sheet.sumas_for(:important_water),
                :relation => Questionnaire::Sheet.sumas_for(:relation)
      }
      haml :stats
    end
  end
end
