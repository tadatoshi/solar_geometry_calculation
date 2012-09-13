require 'spec_helper'

describe SolarGeometryCalculation::SolarPositionCalculation do

  context "declination" do
    
    it "should calculate declination" do
      
      solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 9, :day => 21, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_1.declination.should == -0.19
      
      solar_position_calculation_2 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 1, :day => 21, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_2.declination.should == -20.14
      
      solar_position_calculation_3 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 7, :day => 24, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_3.declination.should == 19.83        
      
    end
    
    context "(solar energy and applications course - homework 2)" do
      
      it "should calculate declination with latitude 45 degrees 28 minutes" do

        solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2012, :month => 2, :day => 19, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
        solar_position_calculation_1.declination.should be_within(0.1).of(-11.95)
                
        # At sunrise 6:50 (6.83h):
        solar_position_calculation_2 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2012, :month => 2, :day => 19, :hour => 6, :minute => 50, :surface_inclination => "0", :surface_azimuth => "0")
        solar_position_calculation_2.declination.should be_within(0.1).of(-12.02)

        # At sunset 17:10 (17.17h):
        solar_position_calculation_3 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 2, :day => 19, :hour => 17, :minute => 10, :surface_inclination => "0", :surface_azimuth => "0")
        solar_position_calculation_3.declination.should be_within(0.1).of(-11.87)     

      end      
      
    end
    
  end

  context "hour angle" do
    
    it "should calculate hour angle" do
      
      solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 9, :day => 21, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_1.hour_angle.should be_within(0.1).of(-42.03)
      
      solar_position_calculation_2 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 1, :day => 21, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_2.hour_angle.should be_within(0.15).of(-1.40)

      solar_position_calculation_3 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 7, :day => 24, :hour => 13, :minute => 15, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_3.hour_angle.should be_within(0.1).of(3.37)           
      
    end
    
  end

  context "height of the sun" do
    
    it "should calculate solar elevation" do
      
      solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 9, :day => 21, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_1.solar_elevation.should be_within(0.1).of(43.09) 
      
      solar_position_calculation_2 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 1, :day => 21, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_2.solar_elevation.should == 24.35
      
      solar_position_calculation_3 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.5", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 7, :day => 24, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_3.solar_elevation.should be_within(0.1).of(61.37)             
      
    end
    
  end
  
  context "Solar azimuth" do
    
    it "should calculate solar azimuth" do
      
      solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.46", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 9, :day => 21, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_1.solar_azimuth.should be_within(0.1).of(-51.58)
      
      solar_position_calculation_2 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.46", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 1, :day => 21, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_2.solar_azimuth.should be_within(0.1).of(-31.03)
      
      solar_position_calculation_3 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.46", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 7, :day => 24, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_3.solar_azimuth.should be_within(0.1).of(-70.83)   

    end
    
  end  
  
  context "Sunrise" do
    
    it "should calculate sunrise" do
      
      solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.46", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 9, :day => 21, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_1.sunrise.should == "6:49"
      
      solar_position_calculation_2 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.46", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 1, :day => 21, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_2.sunrise.should == "7:34"
      
      solar_position_calculation_3 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.46", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 7, :day => 24, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_3.sunrise.should == "5:36"      
      
    end
    
    context "(solar energy and applications course - homework 2)" do
      
      it "should calculate sunrise with latitude 45 degrees 28 minutes" do

        solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2012, :month => 2, :day => 19, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
        solar_position_calculation_1.sunrise.should == "6:59"        

      end      
      
    end        
    
  end

  context "Sunset" do
    
    context "(solar energy and applications course - homework 2)" do
      
      it "should calculate sunset with latitude 45 degrees 28 minutes" do

        solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2012, :month => 2, :day => 19, :hour => 12, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
        solar_position_calculation_1.sunset.should == "17:19"        

      end      
      
    end
    
  end  
  
  context "Angle of incidence" do
    
    it "should calculate angle of incidence" do
      
      solar_position_calculation_1 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 9, :day => 21, :hour => 10, :minute => 0, :surface_inclination => "0", :surface_azimuth => "0")
      solar_position_calculation_1.angle_of_incidence.should be_within(0.1).of(58.73)
      
      solar_position_calculation_2 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 1, :day => 21, :hour => 10, :minute => 0, :surface_inclination => "70", :surface_azimuth => "-45")
      solar_position_calculation_2.angle_of_incidence.should be_within(0.1).of(13.28)
      
      solar_position_calculation_3 = SolarGeometryCalculation::SolarPositionCalculation.new(:latitude => "45.47", :meridian => "-75", :longitude => "-73.75", :timezone_identifier => "America/Montreal", :year => 2010, :month => 7, :day => 24, :hour => 10, :minute => 0, :surface_inclination => "70", :surface_azimuth => "-45")
      solar_position_calculation_3.angle_of_incidence.should == 32.78     
      
    end
    
  end

end