//
//  CurrencyViewModel.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 14.08.2023.
//

import Foundation

class CurrencyViewModel {
    var exchangeRates: CurrencyResponse?
    
    func fetchExchangeRates(completion: @escaping (Error?) -> Void) {
        CurrencyAPIService.fetchExchangeRates { [weak self] result in
            switch result {
            case .success(let rates):
                self?.exchangeRates = rates
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
