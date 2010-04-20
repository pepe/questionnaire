require 'singleton'
module Questionnaire
  class Database
    include Singleton
    class << self
      # returns connection string
      def connection_string
        if environment == :test
          "http://127.0.0.1:5984/test-questionnaires" 
        else
          "http://127.0.0.1:5984/questionnaires" 
        end
      end

      # sets environments
      def environment=(env)
        @connection = nil if @connection
        @environment = env
      end

      # returns environment
      def environment
        @environment ||= :net
      end

      # returns connection
      def connection
        @connection ||= CouchRest.database!(connection_string)
      end
    end
  end
end
