require 'spec/spec_helper'
require 'app/model/sheet'
require 'ruby-debug'
describe "Sheet" do
  before(:all) do
    Questionnaire::Database.connection.recreate!
  end

  describe "Initialization" do
    it "should inialize new sheet" do
      Questionnaire::Sheet.new
    end
    it "should set database to database connection" do
      Questionnaire::Sheet.new.database.name.should == "test-questionnaires"
    end
    it "should have timestamps" do
      sheet = Questionnaire::Sheet.new
      sheet.save
      sheet.created_at.should < Time.now
    end
    it "should have class method for starting new sheet" do
      sheet = Questionnaire::Sheet.start_new
      sheet.should_not be_nil
      sheet.started_at.should < Time.now
    end
  end
  describe "Filling methods" do
    before(:each) do
      @sheet = Questionnaire::Sheet.new
    end
    
    it "should have start method" do
      @sheet.start
      @sheet.started_at.should be_an_instance_of(Time)
      @sheet.started_at.should < Time.now
    end
    it "should have finish method" do
      @sheet.finish
      @sheet.finished_at.should < Time.now
    end
    it "should be filled with form hash" do
      @sheet.update_attributes(
        {"frequency" => "vůbec",
        "frequency_other" => "jak rikam",
        "relation" => "žádný",
        "time_spent" => "questionnaire[time_spent]",
        "purpose_gathering" => "5",
        "purpose_hobbitry" => "5",
        "purpose_fuel" => "5",
        "purpose_relaxation" => "5",
        "favorite_place" => "questionnaire[favorite_place]",
        "once_receive" => "10",
        "once_payment" => "10",
        "important_nature" => "5",
        "important_wood" => "5",
        "important_gathering" => "5",
        "important_water" => "5",
        "important_climate" => "5",
        "important_health" => "5",
        "important_ground" => "5"}).should be_true
      @sheet.update_attributes({:email => 'no@on.cz'})
      @sheet.update_attributes({:note => 'note'})
    end
  end
  describe "Views" do
    before(:all) do
      random_sheets
    end

    it "should return all finished " do
      @sheets = Questionnaire::Sheet.by_finished
      @sheets.size.should == 2
    end
    it "should return all finished ordered by finish time" do
      @sheets = Questionnaire::Sheet.by_finished
      @sheets.sort{|a,b| a.finished_at <=> b.finished_at}.map{|q| q['_id']}.should == @sheets.map{|q| q['_id']}
    end
  end
  describe "Statistics" do
    before(:all) do
      random_sheets(:amount => 5)
    end

    it "should return occurence of each frequency" do
      stats = Questionnaire::Sheet.sumas_for(:frequency)
      stats.should_not be_nil
      stats['vůbec'].should == 3
      stats['1 až 2 x ročně'].should == 2
      stats['all'].should == 5
      %w(purpose_hobbitry purpose_gathering purpose_relaxation
      purpose_fuel important_nature important_wood important_gathering 
      important_water important_climate important_health
      important_ground).each {|attribute|
        stats = Questionnaire::Sheet.sumas_for(attribute.to_sym)
        stats.should_not be_nil
        stats[1].should == 2
        stats[2].should == 1
        stats[3].should == 1
        stats[4].should == 1
        stats[5].should be_nil
      }
      stats = Questionnaire::Sheet.sumas_for(:relation)
      stats.should_not be_nil
      stats['žádný'].should == 5
    end
  end
end

