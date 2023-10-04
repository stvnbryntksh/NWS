//
//  ForecastPeriod.swift
//  NationalWeatherService
//
//  Created by Alan Chu on 4/2/20.
//

import Foundation

extension Forecast {
    public struct Period: Decodable, Identifiable {
                
//        detailedForecast = "Sunny, with a high near 23. North northwest wind 6 to 15 km/h.";
//        dewpoint =     {
//            unitCode = "wmoUnit:degC";
//            value = "15.55555555555556";
//        };
//        endTime = "2023-10-06T18:00:00-07:00";
//        icon = "https://api.weather.gov/icons/land/day/few?size=medium";
//        isDaytime = 1;
//        name = Friday;
//        number = 5;
//        probabilityOfPrecipitation =     {
//            unitCode = "wmoUnit:percent";
//            value = "<null>";
//        };
//        relativeHumidity =     {
//            unitCode = "wmoUnit:percent";
//            value = 82;
//        };
//        shortForecast = Sunny;
//        startTime = "2023-10-06T06:00:00-07:00";
//        temperature = 23;
//        temperatureTrend = "<null>";
//        temperatureUnit = C;
//        windDirection = NNW;
//        windSpeed = "6 to 15 km/h";

        
        public enum CodingKeys: String, CodingKey {
            case name, startTime, endTime, isDaytime
            case temperature, temperatureUnit, relativeHumidity, windSpeed, windDirection, probabilityOfPrecipitation, dewpoint
            case icon, shortForecast, detailedForecast
        }

        public let id = UUID()
        public let name: String?
        public let date: DateInterval
        public let isDaytime: Bool

        public let temperature: Measurement<UnitTemperature>
        public let relativeHumidity: RelativeHumidity?
        public let probabilityOfPrecipitation: ProbabilityOfPrecipitation?
        public let dewPoint: DewPoint?
        public let windSpeed: Wind

        public let conditions: [Condition]
        public let icon: URL
        public let shortForecast: String
        public let detailedForecast: String?

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decodeIfPresent(String.self, forKey: .name)

            let startTime = try container.decode(Date.self, forKey: .startTime)
            let endTime = try container.decode(Date.self, forKey: .endTime)

            self.date = DateInterval(start: startTime, end: endTime)
            self.isDaytime = try container.decode(Bool.self, forKey: .isDaytime)

            let temperatureValue = try container.decode(Double.self, forKey: .temperature)
            let temperatureUnitRaw = try container.decode(String.self, forKey: .temperatureUnit).lowercased()
            let temperatureUnit: UnitTemperature = temperatureUnitRaw == "f" ? .fahrenheit : .celsius

            self.temperature = Measurement(value: temperatureValue, unit: temperatureUnit)

            self.relativeHumidity = try container.decodeIfPresent(RelativeHumidity.self, forKey: .relativeHumidity) ?? nil
            self.probabilityOfPrecipitation = try container.decodeIfPresent(ProbabilityOfPrecipitation.self, forKey: .probabilityOfPrecipitation) ?? nil
            self.dewPoint = try container.decodeIfPresent(DewPoint.self, forKey: .dewpoint) ?? nil

            let windSpeedValue = try container.decode(String.self, forKey: .windSpeed)
            let windDirection = try container.decodeIfPresent(String.self, forKey: .windDirection) ?? ""
            self.windSpeed = try Wind(from: windSpeedValue, direction: windDirection)

            self.icon = try container.decode(URL.self, forKey: .icon)
            self.conditions = Condition.parseFrom(nwsAPIIconURL: self.icon)

            self.shortForecast = try container.decode(String.self, forKey: .shortForecast)
            self.detailedForecast = try container.decode(String.self, forKey: .detailedForecast)
            
        }
    }
}
