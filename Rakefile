QUESTIONNAIRE_ROOT = '.'

require File.expand_path(File.join(File.dirname(__FILE__), 'vendor', 'gems', 'environment'))
Bundler.require_env
require 'rake'
require 'spec/rake/spectask'
require 'cucumber/rake/task'

desc "Runs all specs"
task :default => 'test:spec'

desc "Run tests"
task :start => 'server:start'


task :bootstrap do
  $cache = CouchRest.database!("http://127.0.0.1:5984/questionnaires")
  $cache.recreate!
  $cache.save_doc({ "_id" => "_design/all",
    :views => {
      :list => {
        :map => "function(doc){if(doc[\"start\"] && doc[\"finish\"]){emit(doc[\"_id\"], doc[\"start\"])}}"
  }}})
  $cache.bulk_save([
         {"start" => Time.now.strftime('%D %T'),
        "finish" => Time.now.strftime('%D %T'),
        "frequency" => "vůbec",
        "important_wood" => "5",
        "important_gathering" => "5",
        "frequency_other" => "",
        "relation" => "none",
        "once_receive" => "",
        "time_spent" => "questionnaire[time_spent]",
        "purpose_hobbitry" => "5",
        "favorite_place" => "questionnaire[favorite_place]",
        "important_ground" => "5",
        "important_nature" => "5",
        "purpose_fuel" => "5",
        "purpose_relaxation" => "5",
        "important_water" => "5",
        "important_climate" => "5",
        "important_health" => "5",
        "purpose_gathering" => "5",
        "once_payment" => "10"},
         {"start" => Time.now.strftime('%D %T'),
        "finish" => Time.now.strftime('%D %T'),
        "frequency" => "vůbec",
        "important_wood" => "1",
        "important_gathering" => "1",
        "frequency_other" => "",
        "relation" => "none",
        "once_receive" => "",
        "time_spent" => "questionnaire[time_spent]",
        "purpose_hobbitry" => "1",
        "favorite_place" => "questionnaire[favorite_place]",
        "important_ground" => "1",
        "important_nature" => "1",
        "purpose_fuel" => "1",
        "purpose_relaxation" => "1",
        "important_water" => "1",
        "important_climate" => "1",
        "important_health" => "1",
        "purpose_gathering" => "1",
        "once_payment" => "10"} 
  ])
end

namespace :test do
  Spec::Rake::SpecTask.new do |t|
    FileUtils.rm('test') if File.exists?('test')
    t.spec_files = FileList['spec/*_spec.rb']
    t.spec_opts = ['-u']
  end

  Spec::Rake::SpecTask.new('rcov') do |t|
    t.rcov = true
    t.spec_files = FileList['spec/*_spec.rb']
    t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
  end
  
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format pretty" # Any valid command line option can go here.
    t.rcov = true
  end

  Cucumber::Rake::Task.new(:cruise) do |t|
    t.cucumber_opts = "--format pretty --out=features.txt --format html --out=features.html"
    t.rcov = true
    t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
    t.rcov_opts << %[-o "features_rcov"]
  end
  
  Cucumber::Rake::Task.new(:rcov) do |t|    
    t.rcov = true
    t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
    t.rcov_opts << %[-o "features_rcov"]
  end
end

namespace :bench do
  desc "Runs 1000 benchmark against application"
  task :run do
    file = File.join('bench', Time.now.to_i.to_s)
    puts "* Bench file is #{file}"

    puts "* Doing 1000 requests with concurrence of 4 GET on /"
    command  = %{ab -n1000 -c4 http://questionnaire:9292/ >> #{file}}
    system command

    system %{less #{file}}
  end
end

namespace :stats do
  desc "Returns stats on lines of code in app dir"
  task :run do
    puts "LOC by file with some sums"

    puts code_wc = `wc -mlw  app/*.rb app/**/*.rb | awk '{ printf "%i\\t%s\\n", $1, $4}'` 
    puts test_wc = `wc -mlw  spec/*_spec.rb | awk '{ printf "%i\\t%s\\n", $1, $4}'`
    puts features_wc = `wc -mlw  features/*.feature | awk '{ printf "%i\\t%s\\n", $1, $4}'`
    code_total = code_wc.split("\n").last.split(' ').first.to_f
    test_total = test_wc.split("\n").last.split(' ').first.to_f
    features_total = features_wc.split("\n").last.split(' ').first.to_f

    puts "Test to code ratio: %f" % ((features_total + test_total)/code_total)
  end
end

# namespace :inploy do
  # import 'vendor/plugins/inploy/lib/tasks/inploy.rake'
# end

namespace :server do
  desc "Start server in production on Thin, port 4500"
  task :start do
    exec "thin --rackup config.ru --daemonize --log log/thin.log --pid pids/thin.pid --environment production --port 3000 start && echo '> Questionnaire started on http://localhost:3000'"
  end

  desc "Stop server in production"
  task :stop do
    exec "thin --pid tmp/pids/thin.pid stop"
  end
end

