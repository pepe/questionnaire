require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'environment'))
Bundler.require_env :test

require 'spec/interop/test'

require 'app/lib/database'

Questionnaire::Database.environment = :test

# return app for rack test
def app
  @app ||= Sinatra.new Questionnaire::Application
end

def random_sheets(options = {})
  (options[:amount] || 2).times {|i|
    Questionnaire::Sheet.new.update_attributes(
      {"frequency" => i%2 == 1 ? "1 až 2 x ročně" : "vůbec",
      "frequency_other" => "jak rikam",
      "time_spent" => i*10,
      "purpose_gathering" => (i%4) + 1,
      "purpose_hobbitry" => (i%4) + 1,
      "purpose_fuel" => (i%4) + 1,
      "purpose_relaxation" => (i%4) + 1,
      "favorite_place" => i%2 == 1 ? "Jizerské hory" : "Šumava",
      "once_receive" => 100,
      "once_payment" => 100,
      "important_nature" => (i%4) + 1,
      "important_wood" => (i%4) + 1,
      "important_gathering" => (i%4) + 1,
      "important_water" => (i%4) + 1,
      "important_climate" => (i%4) + 1,
      "important_health" => (i%4) + 1,
      "important_ground" => (i%4) + 1,
      "relation" => "žádný",
      "started_at" => Time.now - (i*90),
      "finished_at" => Time.now - (i*60)
    })
  }
end
