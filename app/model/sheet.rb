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

    %w(frequency purpose_hobbitry purpose_gathering purpose_relaxation
    purpose_fuel important_nature important_wood important_gathering 
    important_water important_climate important_health
    important_ground relation).each {|attribute|
      view_by :"#{attribute}_stats",
        :map => SUMA_MAP % attribute,
        :reduce => SUMA_REDUCE
          }

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
        h = {'all' => 0}
        stats['rows'].each {|s|
          h[s['key']] = s['value']
          h['all'] += s['value']
        }
        return h
      end
    end
  end
end
