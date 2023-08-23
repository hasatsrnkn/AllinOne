//
//  ExchangeRates.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 14.08.2023.
//

import Foundation

struct CurrencyResponse: Codable {
    let data: [String: Currency]
}

struct Currency: Codable {
    let code: String
    let value: Double
}
