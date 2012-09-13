module SolarGeometryCalculation

  module CalculationHelper
  
    def day_of_the_year(year, month, day, hour = 0, minute = 0)
      if hour == 0 && minute == 0
        BigDecimal((Date.new(year.to_i, month.to_i, day.to_i).yday).to_s)
      else
        day_of_the_year_one_day_before = BigDecimal((Date.new(year.to_i, month.to_i, day.to_i).yday).to_s) - 1
        decimal_hour_minute = BigDecimal(hour.to_s) + BigDecimal(minute.to_s) / 60
        (day_of_the_year_one_day_before * 24 + decimal_hour_minute + 12) / 24
      end
    end 
  
    def degree_to_radian(degree)
      degree * BigDecimal(Math::PI.to_s) / 180
    end

    def radian_to_degree(radian)
      radian * 180 / BigDecimal(Math::PI.to_s)
    end  
    
    def big_decimal_sin(angle_in_radian)
      BigDecimal(Math.sin(angle_in_radian).to_s)
    end

    def big_decimal_cos(angle_in_radian)
      BigDecimal(Math.cos(angle_in_radian).to_s)
    end 

    def big_decimal_tan(angle_in_radian)
      BigDecimal(Math.tan(angle_in_radian).to_s)
    end   

    def big_decimal_asin(angle_in_radian)
      BigDecimal(Math.asin(angle_in_radian).to_s)
    end

    def big_decimal_acos(angle_in_radian)
      BigDecimal(Math.acos(angle_in_radian).to_s)
    end    
    
  end

end