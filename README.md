# Solar Geometry Calculation

Calculate solar geometry, such as height or azimuth of the Sun for the purpose of obtaining information for solar panel installation. 


## Installation

Add to your Gemfile and run the `bundle` command to install it.

```ruby
gem "solar_geometry_calculation"
```

**Requires Ruby 1.8.7 or later.**


## Usage

Instantiate SolarPositionCalculation class.

```ruby 1.9.2 or later
solar_position_calculation = SolarPositionCalculation.new(latitude: "45.5")
```

```ruby 1.8.7
solar_position_calculation = SolarPositionCalculation.new(:latitude => "45.5")
``` 


## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/tadatoshi/solar_geometry_calculation/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests passing by running `bundle` and `rake`.

This gem is created by Tadatoshi Takahashi and is under the MIT License.