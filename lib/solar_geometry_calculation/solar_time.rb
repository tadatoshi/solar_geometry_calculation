require 'tzinfo'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/date/calculations'

module SolarGeometryCalculation

  class SolarTime
  
    attr_accessor :year, :month, :day, :hour, :minute, :meridian, :longitude, :timezone_identifier
    attr_writer :standard_time
  
    # Methods for standard_time provided because the method to get minute for Time is min and that naming is not consistent with minute method for this class: 
    def standard_time_year
      @standard_time.year
    end
  
    def standard_time_month
      @standard_time.month
    end
  
    def standard_time_day
      @standard_time.day
    end
  
    def standard_time_hour
      @standard_time.hour
    end
  
    def standard_time_minute
      @standard_time.min
    end
  
    class << self
    
      # Moved from app/models/factories/solar_time_factory.rb because "rails server" in development environment cannot find this module. 
      # -- At least after I tried rack-mini-profiler. Even after I commented it out in Gemfile, the problem still persists.
      def create_by_standard_time(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)
        solar_time = SolarTime.new

        # Uses Time because DateTime doesn't take daylight savings time even with the one from Rails:
        solar_time.standard_time = Time.new(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute)

        solar_time.meridian = meridian
        solar_time.longitude = longitude
        solar_time.timezone_identifier = timezone_identifier 

        standard_time_year_without_offset, standard_time_month_without_offset, standard_time_day_without_offset, standard_time_hour_without_offset, standard_time_minute_without_offset = 
          SolarTime.standard_time_without_daylight_savings_time_offset(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)    

        solar_time.year, solar_time.month, solar_time.day, solar_time.hour, solar_time.minute = 
          SolarTime.standard_time_without_daylight_savings_time_offset_to_solar_time(standard_time_year_without_offset, standard_time_month_without_offset, standard_time_day_without_offset, standard_time_hour_without_offset, standard_time_minute_without_offset, meridian, longitude, timezone_identifier)

        solar_time
      end
    
      # Moved from app/models/factories/solar_time_factory.rb because "rails server" in development environment cannot find this module. 
      # -- At least after I tried rack-mini-profiler. Even after I commented it out in Gemfile, the problem still persists.
      def create_by_solar_time_values(solar_time_year, solar_time_month, solar_time_day, solar_time_hour, solar_time_minute, meridian, longitude, timezone_identifier)
        solar_time = SolarTime.new
        solar_time.year = solar_time_year
        solar_time.month = solar_time_month
        solar_time.day = solar_time_day
        solar_time.hour = solar_time_hour
        solar_time.minute = solar_time_minute
        solar_time.meridian = meridian
        solar_time.longitude = longitude    
        solar_time.timezone_identifier = timezone_identifier    

        standard_time_year_without_offset, standard_time_month_without_offset, standard_time_day_without_offset, standard_time_hour_without_offset, standard_time_minute_without_offset = 
          SolarTime.solar_time_to_standard_time_without_daylight_savings_time_offset(solar_time.year, solar_time.month, solar_time.day, solar_time.hour, solar_time.minute, meridian, longitude, timezone_identifier)

        standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute = 
          SolarTime.standard_time_with_daylight_savings_time_offset(standard_time_year_without_offset, standard_time_month_without_offset, standard_time_day_without_offset, standard_time_hour_without_offset, standard_time_minute_without_offset, meridian, longitude, timezone_identifier)

        # Uses Time because DateTime doesn't take daylight savings time even with the one from Rails:
        solar_time.standard_time = Time.new(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute)

        solar_time
      end    
    
      def standard_time_without_daylight_savings_time_offset(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)
        NegativeDaylightSavingsTimeConverter.new.convert(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)
      end
    
      def standard_time_with_daylight_savings_time_offset(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)
        PositiveDaylightSavingsTimeConverter.new.convert(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)
      end    

      def standard_time_without_daylight_savings_time_offset_to_solar_time(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)
        ToSolarTimeConverter.new.convert(standard_time_year, standard_time_month, standard_time_day, standard_time_hour, standard_time_minute, meridian, longitude, timezone_identifier)
      end   
    
      def solar_time_to_standard_time_without_daylight_savings_time_offset(solar_time_year, solar_time_month, solar_time_day, solar_time_hour, solar_time_minute, meridian, longitude, timezone_identifier)
        FromSolarTimeConverter.new.convert(solar_time_year, solar_time_month, solar_time_day, solar_time_hour, solar_time_minute, meridian, longitude, timezone_identifier)
      end    

    end
  
  end

  module TimeConverter
  
    def convert(year, month, day, hour, minute, meridian, longitude, timezone_identifier)

      # Creating Time object as UTC since Time.local gets Time object in machine's timezone. 
      time = Time.utc(year, month, day, hour, minute)

      time = convert_by_offset(time, meridian, longitude, timezone_identifier)

      [BigDecimal(time.year.to_s), BigDecimal(time.month.to_s), BigDecimal(time.day.to_s), BigDecimal(time.hour.to_s), BigDecimal(time.min.to_s)]

    end
  
    private
      def convert_by_offset(time, meridian, longitude, timezone_identifier)
        raise "must be implemented by a class"
      end
  
      def target_time(time, offset_in_seconds)
        raise "must be implemented by a class"
      end
    
  end  

  module DaylightSavingsTimeConverter 
    include TimeConverter
  
    private
      def convert_by_offset(time, meridian, longitude, timezone_identifier)
        timezone = TZInfo::Timezone.get(timezone_identifier)
        timezone_period = timezone.period_for_local(time, true)

        if timezone_period.dst?
          time = target_time(time, timezone_period.std_offset)
        end
      
        time
      end    
  
      def target_time(time, offset_in_seconds)
        raise "must be implemented by a class"
      end
  
  end

  module SolarTimeConverter 
    include TimeConverter
    include SolarGeometryCalculation::CalculationHelper
  
    private
      def convert_by_offset(time, meridian, longitude, timezone_identifier)
        minutes_difference = minutes_difference(time.year, time.month, time.day, meridian, longitude)
        time = target_time(time, minutes_difference * 60)
      end    

      def target_time(time, offset_in_seconds)
        raise "must be implemented by a class"
      end
  
      def minutes_difference(year, month, day, meridian, longitude)
        -(4 * (BigDecimal(meridian.to_s) - BigDecimal(longitude.to_s))) + equation_of_time(year, month, day).round
      end    

      def equation_of_time(year, month, day)
        b_in_radian = degree_to_radian((day_of_the_year(year, month, day) - 1) * BigDecimal("360") / BigDecimal("365"))
  
        BigDecimal("229.2") * (BigDecimal("0.000075") + BigDecimal("0.001868") * big_decimal_cos(b_in_radian) - BigDecimal("0.032077") * big_decimal_sin(b_in_radian) - BigDecimal("0.014615") * big_decimal_cos(2 * b_in_radian) - BigDecimal("0.04089") * big_decimal_sin(2 * b_in_radian))                  
      end
  
  end

  module OffsetAdvanceConverter
    private
      def target_time(time, offset_in_seconds)
        time.advance(seconds: offset_in_seconds)
      end    
  end

  module OffsetSubtractionConverter
    private
      def target_time(time, offset_in_seconds)
        time.ago(offset_in_seconds)
      end    
  end  

  class NegativeDaylightSavingsTimeConverter
    include DaylightSavingsTimeConverter
    include OffsetSubtractionConverter
  end

  class PositiveDaylightSavingsTimeConverter
    include DaylightSavingsTimeConverter
    include OffsetAdvanceConverter 
  end  

  class ToSolarTimeConverter
    include SolarTimeConverter
    include OffsetAdvanceConverter
  end

  class FromSolarTimeConverter
    include SolarTimeConverter
    include OffsetSubtractionConverter
  end  

end