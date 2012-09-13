require 'spec_helper'

describe SolarGeometryCalculation::CalculationHelper do
  
  class CalculationHelperExtender; extend SolarGeometryCalculation::CalculationHelper; end
  
  context "Day of the year" do
  
    it "should calculate the day of the year" do
    
      CalculationHelperExtender.day_of_the_year(2012, 2, 19).should == 50
    
    end
    
    it "should calculate the day of the year taking into account of the time in the day" do
      
      CalculationHelperExtender.day_of_the_year(2012, 2, 19, 6, 50).should be_within(0.01).of(49.78)
      CalculationHelperExtender.day_of_the_year(2012, 2, 19, 17, 10).should be_within(0.01).of(50.22)
      
    end
  
  end
  
  context "Radian degree" do
    
    it "should convert a degree to Radian because Math.sin expects Radian" do
      
      CalculationHelperExtender.degree_to_radian(1).should be_within(0.0001).of(0.0175)
      
    end
    
    it "should convert radian to degree" do
      
      CalculationHelperExtender.radian_to_degree(1).should be_within(0.0001).of(57.2958)
      
    end    
    
  end  
  
end