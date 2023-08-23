//
//  GasPriceViewModel.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 14.08.2023.
//

import Foundation

class GasPriceViewModel {
    func fetchGasPrices(city: String, completion: @escaping (Result<GasPriceInfo, Error>) -> Void) {
        NetworkService.fetchGasPrices(city: city, completion: completion)
    }
}

