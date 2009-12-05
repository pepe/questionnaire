require 'app/application'

$cache = CouchRest.database!("http://127.0.0.1:5984/questionnaires")

run Questionnaire::Application
