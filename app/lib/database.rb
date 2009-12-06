require 'singleton'
module Questionnaire
  class Database
    include Singleton
    # returns connection string
    def self.connection_string
      if @environment == :test
        "http://127.0.0.1:5984/test-questionnaires" 
      else
        "http://127.0.0.1:5984/questionnaires" 
      end
    end

    # sets environments
    def self.environment=(env)
      @environment = env
    end

    # returns environment
    def self.environment
      @environment
    end

    # returns connection
    def self.connection
      @connection ||= CouchRest.database!(connection_string)
    end
  end
end
