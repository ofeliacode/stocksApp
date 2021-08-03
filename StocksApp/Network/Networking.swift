//
//  Networking.swift
//  StocksApp
//
//  Created by Офелия on 28.07.2021.
//

import Foundation
import UIKit

protocol NetworkingProtocol {
    func loadData(completionHandler: @escaping (Result<[Stock], Error>)-> Void)
}

class Networking: NetworkingProtocol {
    func loadData(completionHandler: @escaping (Result<[Stock], Error>) -> Void) {
        let str = "http://phisix-api3.appspot.com/stocks.json"
        guard let url = URL(string: str) else { return }
        URLSession.shared.dataTask(with: url) {  (data, response, error) in
            guard let data = data else { return }
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            do {
                let json = try JSONDecoder().decode(StockArray.self, from: data)
                completionHandler(.success(json.stock ?? []))
            } catch let jsonError {
                completionHandler(.failure(jsonError))
                print("no work")
            }
        }.resume()
    }
}



