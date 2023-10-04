//
//  File.swift
//
//
//  Created by Steven Bryant Kish on 10/4/23.
//

import Foundation

public struct DewPoint: Decodable {

    //        dewpoint =     {
    //            unitCode = "wmoUnit:degC";
    //            value = "15.55555555555556";
    //        };

    public enum CodingKeys: String, CodingKey {
        case unitCode, value
    }
    
    public let measurement : Measurement<UnitTemperature>?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let unitCodeRaw = try container.decode(String.self, forKey: .unitCode).lowercased()
        let unitCode = unitCodeRaw.components(separatedBy: ":")[1]
        let valueRaw : Double? = try container.decodeIfPresent(Double.self, forKey: .value)
                
        if valueRaw != nil {
            let temperatureUnit: UnitTemperature = unitCode == "degc" ? .celsius : .fahrenheit
            self.measurement = Measurement(value: valueRaw!, unit: temperatureUnit)
        }
        else {
            self.measurement = nil
        }
    }
}
