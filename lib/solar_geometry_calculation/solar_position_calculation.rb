require 'active_support/core_ext/object/blank'

module SolarGeometryCalculation

  class SolarPositionCalculation
  	include CalculationHelper

    attr_accessor :id, :latitude, :meridian, :longitude, :year, :month, :day, :hour, :minute, :surface_inclination, :surface_azimuth, :solar_time
    attr_writer :timezone_identifier

    def initialize(attributes = {})
      attributes.each { |attribute_name, attribute_value| self.send("#{attribute_name}=".to_sym, attribute_value) }
      get_solar_time
    end


    def declination(with_hour_and_minutes: true)
      day_of_the_year = with_hour_and_minutes ? day_of_the_year(@solar_time.year, @solar_time.month, @solar_time.day, @solar_time.hour, @solar_time.minute) : day_of_the_year(@solar_time.year, @solar_time.month, @solar_time.day)
      radian = degree_to_radian(BigDecimal("360") / BigDecimal("365") * (day_of_the_year + 284))
      (23.45 * big_decimal_sin(radian)).round(2)
    end

    def hour_angle
      if @solar_time.blank?
        hour_for_calculation = BigDecimal(@hour.to_s)
        minute_for_calculation = BigDecimal(@minute.to_s)
      else
        hour_for_calculation = @solar_time.hour
        minute_for_calculation = @solar_time.minute
      end

      hour_with_minutes_in_digit = hour_for_calculation + minute_for_calculation.div(60, 2)

      ((hour_with_minutes_in_digit - 12) * 15).round(2)
    end

    def solar_elevation
      latitude_in_radian = degree_to_radian(BigDecimal(self.latitude.to_s))
      declination_in_radian = degree_to_radian(self.declination)
      hour_angle_in_radian = degree_to_radian(self.hour_angle)

      sine_solar_elevation = big_decimal_sin(latitude_in_radian) * big_decimal_sin(declination_in_radian) +
                             big_decimal_cos(latitude_in_radian) * big_decimal_cos(declination_in_radian) * big_decimal_cos(hour_angle_in_radian)
      radian_to_degree(big_decimal_asin(sine_solar_elevation)).round(2)
    end

    def solar_azimuth
      declination_in_radian = degree_to_radian(self.declination)
      hour_angle_in_radian = degree_to_radian(self.hour_angle)
      solar_elevation_in_radian = degree_to_radian(self.solar_elevation)

      sine_solar_azimuth = big_decimal_cos(declination_in_radian) * big_decimal_sin(hour_angle_in_radian) / big_decimal_cos(solar_elevation_in_radian)
      radian_to_degree(big_decimal_asin(sine_solar_azimuth)).round(2)
    end

    def sunrise
      sunrise_time_with_munutes_in_digit = BigDecimal((12 - (sunrise_sunset_base_angle / 15)).to_s)
      sunrise_sunset_time(sunrise_time_with_munutes_in_digit)
    end

    def sunset
      sunset_time_with_munutes_in_digit = BigDecimal((12 + (sunrise_sunset_base_angle / 15)).to_s)
      sunrise_sunset_time(sunset_time_with_munutes_in_digit)
    end

    def angle_of_incidence
      latitude_in_radian = degree_to_radian(BigDecimal(self.latitude.to_s))
      declination_in_radian = degree_to_radian(self.declination)
      hour_angle_in_radian = degree_to_radian(self.hour_angle)
      surface_inclination_in_radian = degree_to_radian(BigDecimal(@surface_inclination.to_s))
      surface_azimuth_in_radian = degree_to_radian(BigDecimal(@surface_azimuth.to_s))

      first_value = big_decimal_sin(declination_in_radian) * big_decimal_sin(latitude_in_radian) * big_decimal_cos(surface_inclination_in_radian)
      second_value = big_decimal_sin(declination_in_radian) * big_decimal_cos(latitude_in_radian) * big_decimal_sin(surface_inclination_in_radian) * big_decimal_cos(surface_azimuth_in_radian)
      third_value = big_decimal_cos(declination_in_radian) * big_decimal_cos(latitude_in_radian) * big_decimal_cos(surface_inclination_in_radian) * big_decimal_cos(hour_angle_in_radian)
      fourth_value = big_decimal_cos(declination_in_radian) * big_decimal_sin(latitude_in_radian) * big_decimal_sin(surface_inclination_in_radian) * big_decimal_cos(surface_azimuth_in_radian) * big_decimal_cos(hour_angle_in_radian)
      fifth_value = big_decimal_cos(declination_in_radian) * big_decimal_sin(surface_inclination_in_radian) * big_decimal_sin(surface_azimuth_in_radian) * big_decimal_sin(hour_angle_in_radian)
      cosine_of_angle_of_incidence = first_value - second_value + third_value + fourth_value + fifth_value

      radian_to_degree(big_decimal_acos(cosine_of_angle_of_incidence)).round(2)
    end

    private
      def get_solar_time
        if @year.present? && @month.present? && @day.present?
          if @address.present? && @place.present?
            @solar_time = SolarTime.create_by_standard_time(BigDecimal(@year.to_s), BigDecimal(@month.to_s), BigDecimal(@day.to_s), BigDecimal(@hour.to_s), BigDecimal(@minute.to_s), @place.meridian, @place.longitude, @place.timezone_identifier)
          elsif @meridian.present? && @longitude.present? && @timezone_identifier.present?
            @solar_time = SolarTime.create_by_standard_time(BigDecimal(@year.to_s), BigDecimal(@month.to_s), BigDecimal(@day.to_s), BigDecimal(@hour.to_s), BigDecimal(@minute.to_s), @meridian, @longitude, @timezone_identifier)
          else
            throw "Could not generate @solar_time with available data: #{self.inspect}"
          end
        end
      end

      def sunrise_sunset_base_angle
        latitude_in_radian = degree_to_radian(BigDecimal(self.latitude.to_s))
        declination_in_radian = degree_to_radian(self.declination(with_hour_and_minutes: false))

        sunrise_sunset_base_angle_in_radian = big_decimal_acos(-(big_decimal_tan(latitude_in_radian) * big_decimal_tan(declination_in_radian)))
        radian_to_degree(sunrise_sunset_base_angle_in_radian)
      end

      def sunrise_sunset_time(sunrise_or_sunset_time_with_munute_in_digit)
        sunrise_or_sunset_hour, sunrise_or_sunset_minute_in_10_base = sunrise_or_sunset_time_with_munute_in_digit.divmod(1)
        sunrise_or_sunset_solar_time = SolarTime.create_by_solar_time_values(@solar_time.year, @solar_time.month, @solar_time.day, sunrise_or_sunset_hour, (sunrise_or_sunset_minute_in_10_base * 60).round, @meridian, @longitude, @solar_time.timezone_identifier)
        "#{sunrise_or_sunset_solar_time.standard_time_hour.to_i}:#{self.class.format_minute(sunrise_or_sunset_solar_time.standard_time_minute.to_i)}"
      end

    class << self
      def format_minute(minute)
        minute.to_s.length == 1 ? "0#{minute.to_s}" : minute.to_s
      end
    end

  end

end