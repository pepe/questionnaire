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

    SUMA_MAP = "function(doc){
            if(doc['couchrest-type'] == 'Questionnaire::Sheet' && doc.started_at && doc.finished_at){
              emit(doc.%s, 1);
            }
          }"
    SUMA_REDUCE = "function(keys, values, rereduce){return sum(values);}"

    view_by :finished,
        :map =>
          "function(doc){
            if(doc.started_at && doc.finished_at){
              emit(doc.finished_at, doc);
            }
          }"

    view_by :frequency_stats,
        :map => SUMA_MAP % "frequency",
        :reduce => SUMA_REDUCE
          

    view_by :purpose_gathering_stats,
        :map => SUMA_MAP % "purpose_gathering",
        :reduce => SUMA_REDUCE

    view_by :purpose_hobbitry_stats,
        :map => SUMA_MAP % "purpose_hobbitry",
        :reduce => SUMA_REDUCE

    view_by :purpose_fuel_stats,
        :map => SUMA_MAP % "purpose_fuel",
        :reduce => SUMA_REDUCE

    view_by :purpose_relaxation_stats,
        :map => SUMA_MAP % "purpose_relaxation",
        :reduce => SUMA_REDUCE

    view_by :important_nature_stats,
        :map => SUMA_MAP % "important_nature",
        :reduce => SUMA_REDUCE

    view_by :important_wood_stats,
        :map => SUMA_MAP % "important_wood",
        :reduce => SUMA_REDUCE

    view_by :important_gathering_stats,
        :map => SUMA_MAP % "important_gathering",
        :reduce => SUMA_REDUCE

    view_by :important_water_stats,
        :map => SUMA_MAP % "important_water",
        :reduce => SUMA_REDUCE

    view_by :important_climate_stats,
        :map => SUMA_MAP % "important_climate",
        :reduce => SUMA_REDUCE

    view_by :important_health_stats,
        :map => SUMA_MAP % "important_health",
        :reduce => SUMA_REDUCE

    view_by :important_ground_stats,
        :map => SUMA_MAP % "important_ground",
        :reduce => SUMA_REDUCE


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

      # returns statistics array for parameter
      def sumas_for(attribute)
        stats = send("by_%s_stats" % attribute, :reduce => true, :group => true)
        h = {}
        stats['rows'].each {|s| h[s['key']] = s['value']}
        return h
      end
    end
  end
end
