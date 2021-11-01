//
//  Exchange.swift
//  CurrencyExchange
//
//  Created by lake on 10/20/21.
//

import Foundation

public struct Pairs: Codable
{
    var message: String
    var supportedPairs: [String]
    var code: Int
}

public struct ExchangeRate: Codable
{
    var rates: Dictionary<String, Dictionary<String, Double>>
    var code: Int
}
