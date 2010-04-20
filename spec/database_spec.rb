require 'spec/spec_helper'
require 'couchrest'

describe "Database" do
  context "retrieving connection string based on environment" do
    Questionnaire::Database.environment = :net
    Questionnaire::Database.connection_string.should == "http://127.0.0.1:5984/questionnaires"
    Questionnaire::Database.environment = :test
    Questionnaire::Database.connection_string.should == "http://127.0.0.1:5984/test-questionnaires"
  end

  context "retrieving database" do
    Questionnaire::Database.environment = :net
    Questionnaire::Database.connection.name.should == CouchRest.database("http://127.0.0.1:5984/questionnaires").name
    Questionnaire::Database.environment = :test
    Questionnaire::Database.connection.name.should == CouchRest.database("http://127.0.0.1:5984/test-questionnaires").name
  end
end
