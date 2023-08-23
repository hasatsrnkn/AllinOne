import Foundation


import Foundation

import Foundation

struct GasPriceInfo: Decodable {
    let data: [String: GasData]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([String: GasData].self, forKey: .data)
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct GasData: Decodable {
    let fuelPrices: [String: String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        var fuelPrices = [String: String]()

        for key in container.allKeys {
            if let value = try? container.decode(String.self, forKey: key) {
                fuelPrices[key.stringValue] = value
            }
        }

        self.fuelPrices = fuelPrices
    }
}

struct DynamicKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}






// Remove the GasPriceValue enum and its associated code
