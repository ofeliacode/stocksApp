//
//  Model.swift
//  StocksApp
//
//  Created by Офелия on 25.06.2021.
//

import Foundation
import UIKit

struct StockArray: Codable {
    var stock: [Stock]?
}
struct Stock: Codable {
    var name: String
    var volume: Int
    var price: Price?
    var symbol: String
    var percentChange: Double
    var isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
            case name, price
            case percentChange = "percent_change"
            case volume, symbol, isFavorite
        }
}

struct Price: Codable {
    var currency: String?
    var amount: Double
}




