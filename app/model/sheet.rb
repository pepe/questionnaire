require 'app/application'
module Questionnaire
  class Sheet < CouchRest::ExtendedDocument
    use_database Database.connection
    timestamps!
    property :started_at, :cast_as => 'Time'
    property :finished_at, :cast_as => 'Time'
    property :frequency
    property :frequency_other
    property :purpose_fuel
    property :purpose_relaxation
    property :purpose_gathering
    property :purpose_hobbitry
    property :favorite_place
    property :time_spent
    property :once_receive
    property :once_payment
    property :important_ground
    property :important_nature
    property :important_wood
    property :important_gathering
    property :important_water
    property :important_climate
    property :important_health
    property :relation
    property :email
    property :note

    view_by :finished,
        :map =>
          "function(doc){
            if(doc[\"started_at\"] && doc[\"finished_at\"]){
              emit(doc[\"finished_at\"], doc)
            }
          }"

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
