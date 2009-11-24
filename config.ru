require 'app/application'

use Rack::Session::Cookie

run Questionnaire::Application

