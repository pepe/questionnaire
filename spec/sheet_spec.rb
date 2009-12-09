require 'spec/spec_helper'
require 'app/model/sheet'
require 'ruby-debug'
describe "Sheet" do
  context "Initialization" do
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

  context "Filling methods" do
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
        "relation" => "none",
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

  context "Views" do
    before(:each) do
      Questionnaire::Database.connection.recreate!
      10.times {
        sheet = Questionnaire::Sheet.start_new
        sheet.finish
        sheet.update_attributes({"frequency" => "vůbec",
          "frequency_other" => "jak rikam",
          "relation" => "none",
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
          "important_ground" => "5"})
      }
    end

    it "should return all finished " do
      @sheets = Questionnaire::Sheet.by_finished
      @sheets.size.should == 10
    end
  end
end
