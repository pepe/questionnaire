require 'app/lib/database'
describe "Database" do
  context "retrieving connection string based on environment" do
    Questionnaire::Database.connection_string.should == "http://127.0.0.1:5984/questionnaires"
    Questionnaire::Database.environment = :test
    Questionnaire::Database.connection_string.should == "http://127.0.0.1:5984/test-questionnaires"
  end

  context "retrieving database" do
    Questionnaire::Database.connection == CouchRest.database!("http://127.0.0.1:5984/questionnaires")
  end
end
