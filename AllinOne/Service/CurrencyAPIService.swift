//
//  CurrencyAPIService.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 14.08.2023.
//

import Foundation

struct CurrencyAPIService {
    static let baseURL = "https://api.currencyapi.com/v3/latest?apikey=\(globalApiKey)&currencies=EUR%2CUSD%2CGBP&base_currency=TRY"
    
    static func fetchExchangeRates(completion: @escaping (Result<CurrencyResponse, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let exchangeRates = try decoder.decode(CurrencyResponse.self, from: data)
                    completion(.success(exchangeRates))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


enum APIError: Error {
    case invalidURL
}
