require 'spec_helper'

describe SolarGeometryCalculation::SolarTime do
  
  context "Factory" do
    
    it "should create an instance based on the standard time" do
      
      solar_time = SolarGeometryCalculation::SolarTime.create_by_standard_time(2010, 9, 21, 12, 0, -75, -73.75, "America/Los_Angeles")
      
      solar_time.standard_time_year.should == 2010
      solar_time.standard_time_month.should == 9
      solar_time.standard_time_day.should == 21
      solar_time.standard_time_hour.should == 12
      solar_time.standard_time_minute.should == 0
      
      solar_time.year.should == 2010
      solar_time.month.should == 9
      solar_time.day.should == 21
      solar_time.hour.should == 11
      solar_time.minute.should == 12 
      
    end
    
    it "should create an instance based on the solar time values" do
      
      solar_time = SolarGeometryCalculation::SolarTime.create_by_solar_time_values(2010, 9, 21, 11, 12, -75, -73.75, "America/Los_Angeles")
      
      solar_time.year.should == 2010
      solar_time.month.should == 9
      solar_time.day.should == 21
      solar_time.hour.should == 11
      solar_time.minute.should == 12 
      
      solar_time.standard_time_year.should == 2010
      solar_time.standard_time_month.should == 9
      solar_time.standard_time_day.should == 21
      solar_time.standard_time_hour.should == 12
      solar_time.standard_time_minute.should == 0 
      
    end    
  
  end  

  context "helper" do
  
    it "should get the time without daylight saving time offset from the time with daylight saving time offset" do
    
      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset, 2012, 07, 13, 10, 12, -75, -78.63, "America/Los_Angeles").should == [2012, 7, 13, 9, 12]
      
      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset, 2012, 8, 1, 0, 30, -75, -78.63, "America/Los_Angeles").should == [2012, 7, 31, 23, 30]      
    
    end
    
    it "should get the time with daylight saving time offset from the time without daylight saving time offset" do
    
      SolarGeometryCalculation::SolarTime.send(:standard_time_with_daylight_savings_time_offset, 2012, 07, 13, 9, 12, -75, -78.63, "America/Los_Angeles").should == [2012, 7, 13, 10, 12]
      
      SolarGeometryCalculation::SolarTime.send(:standard_time_with_daylight_savings_time_offset, 2012, 7, 31, 23, 30, -75, -78.63, "America/Los_Angeles").should == [2012, 8, 1, 0, 30]      
    
    end    

    it "should calculate solar time" do

      # Data for Toronto:
      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset_to_solar_time, 2010, 2, 19, 7, 14, -75, -78.63, "America/Los_Angeles").should == [2010, 2, 19, 6, 45]        

      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset_to_solar_time, 2010, 9, 21, 10, 0, -75, -73.55, "America/Los_Angeles").should == [2010, 9, 21, 10, 12]

      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset_to_solar_time, 2010, 9, 21, 10, 0, BigDecimal("-75"), BigDecimal("-73.55"), "America/Los_Angeles").should == [2010, 9, 21, 10, 12]

      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset_to_solar_time, 2010, 9, 21, 10, 0, -75, -78.30, "America/Los_Angeles").should == [2010, 9, 21, 9, 53]

      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset_to_solar_time, 2010, 8, 1, 0, 0, -75, -78.30, "America/Los_Angeles").should == [2010, 7, 31, 23, 39]    

      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset_to_solar_time, 2010, 7, 31, 23, 59, -75, -78.30, "America/Los_Angeles").should == [2010, 7, 31, 23, 38]    

      SolarGeometryCalculation::SolarTime.send(:standard_time_without_daylight_savings_time_offset_to_solar_time, 2010, 9, 21, 12, 0, -75, -73.75, "America/Los_Angeles").should == [2010, 9, 21, 12, 12]    

    end    
    
  end

  context "(solar energy and applications course - homework 2)" do
    
    it "should calculate average solar hour" do

      solar_time_1 = SolarGeometryCalculation::SolarTime.create_by_standard_time(2012, 02, 19, 12, 30, -75, -73.75, "America/Los_Angeles")
      solar_time_1.year.should == 2012
      solar_time_1.month.should == 2
      solar_time_1.day.should == 19
      solar_time_1.hour.should == 12
      solar_time_1.minute.should be_within(1).of(21)
      
      solar_time_2 = SolarGeometryCalculation::SolarTime.create_by_standard_time(2012, 02, 19, 12, 30, BigDecimal("-75"), BigDecimal("-73.75"), "America/Los_Angeles")
      solar_time_1.year.should == 2012
      solar_time_1.month.should == 2
      solar_time_1.day.should == 19
      solar_time_1.hour.should == 12
      solar_time_1.minute.should be_within(1).of(21)     

    end    
    
  end
  
  context "converter" do
    
    class TempSolarTimeConverter; include SolarGeometryCalculation::SolarTimeConverter; end

    it "should calculate the adjustment by the Equation of time" do
    
      TempSolarTimeConverter.new.send(:equation_of_time, 2012, 02, 19).should be_within(0.01).of(-14.11)
  
    end
  
  end

end