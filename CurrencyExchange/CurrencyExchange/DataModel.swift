//
//  DataModel.swift
//  CurrencyExchange
//
//  Created by lake on 10/20/21.
//

import Foundation
public class DataModel: ObservableObject
{
    @Published var pairs: [String] = [""]
    @Published var currencies: [String] = [""]
   
    
    //https://www.freeforexapi.com/api/live
    //https://www.freeforexapi.com/api/live?pairs=USDCAD
    
    //Singleton
    static let dataModel = DataModel()
    
    static var sharedInstance: DataModel
    {
        return self.dataModel
    }
    
    
    public func convertTimeStamp(timestamp: Double) -> String
    {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    public func getCurrencies() -> [String]
     {
         var currenciesSet = Set<String>()
         for pair in pairs
         {
             let firstCurrency = pair.getSubString(0, 3)
             let secondCurrency = pair.getSubString(3, 6)
             currenciesSet.insert(firstCurrency)
             currenciesSet.insert(secondCurrency)
         }
         currencies = Array(currenciesSet).sorted()
         return currencies
     }
  
   
}
