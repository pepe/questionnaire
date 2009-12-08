require 'app/application'
module Questionnaire
  class Sheet < CouchRest::ExtendedDocument
    use_database Database.connection
    timestamps!
    property :started_at
    property :finished_at
    property :frequency
    property :important_wood
    property :important_gathering
    property :frequency_other
    property :relation
    property :once_receive
    property :time_spent
    property :purpose_hobbitry
    property :favorite_place
    property :important_ground
    property :important_nature
    property :purpose_fuel
    property :purpose_relaxation
    property :important_water
    property :important_climate
    property :important_health
    property :purpose_gathering
    property :once_payment
    property :email
    property :note

    # starts questionnaire
    def start
      self.started_at = Time.now
    end

    # finishs questionnaire
    def finish
      self.finished_at = Time.now
    end

    class << self
      def start_new
        ret = new
        ret.start
        return ret
      end
    end
  end
end
