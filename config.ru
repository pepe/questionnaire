require 'app/application'

Questionnaire::Database.environment = :net

run Questionnaire::Application
