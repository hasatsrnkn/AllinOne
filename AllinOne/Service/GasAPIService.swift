//
//  GasAPIService.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 14.08.2023.
//
import Foundation

class NetworkService {
    static func fetchGasPrices(city: String, completion: @escaping (Result<GasPriceInfo, Error>) -> Void) {
        let urlStr = "http://hasanadiguzel.com.tr/api/akaryakit/sehir=\(city)"
        guard let url = URL(string: urlStr) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let headers = [
            "content-type": "application/json"
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let gasPriceResponse = try JSONDecoder().decode(GasPriceInfo.self, from: data)
                    completion(.success(gasPriceResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        dataTask.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
}


