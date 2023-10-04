//
//  File.swift
//  
//
//  Created by Steven Bryant Kish on 10/4/23.
//

import Foundation

public struct RelativeHumidity: Decodable {

    //        relativeHumidity =     {
    //            unitCode = "wmoUnit:percent";
    //            value = 82;
    //        };

    public enum CodingKeys: String, CodingKey {
        case unitCode, value
    }

    public let percent : Double?
    public let normal : Double?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.percent = try container.decodeIfPresent(Double.self, forKey: .value)
        if self.percent != nil {
            self.normal = self.percent! / 100.0
        }
        else {
            self.normal = nil
        }
  }
}
