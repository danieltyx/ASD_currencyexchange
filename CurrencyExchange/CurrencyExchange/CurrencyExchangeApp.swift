//
//  CurrencyExchangeApp.swift
//  CurrencyExchange
//
//  Created by lake on 10/18/21.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App
{
    let dataModel = DataModel.sharedInstance
    let manager = PListManager()
    
    init()
    {
        loadPairsData()
        //printModel()
        //saveModel()
        //readSavedModel()
        //deleteSavedModel()
    }
    
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environmentObject(dataModel)
        }
       
    }
    
    //loads all the supported pairs into the DataModel
    func loadPairsData()
    {
        let urlString = "https://www.freeforexapi.com/api/live"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data
            {
                     if let responseDecoder = try? JSONDecoder().decode(Pairs.self, from: data)
                     {
                         DispatchQueue.main.async
                         {
                             print(responseDecoder)
                             dataModel.pairs = responseDecoder.supportedPairs
                             
                             
                             
                             let testarry = dataModel.getCurrencies() as [String]
                             let currenciesDictionary = ["currencies":testarry]
                             
                             manager.writePlist(namePlist: "Currencies", key: "currencies", data: currenciesDictionary as AnyObject)
                             
                         }
                         
                     }

            }
        }.resume()
    }
    
    
    //EXAMPLES: How to work with the plist manager
    //These are just examples and not the solutions to the project tasks
    //Prints the Exchange plist model
    func printModel()
    {
        print(manager.readAllPlistFromMainBundle(namePlist: "Exchange"))
    }
    
    //Save the online data model into the Exchange plist
    func saveModel()
    {
        //Dictionary<String, Dictionary<String, Double>>
        let rateDictionary = ["rate": 1.23612, "timestamp": dataModel.convertTimeStamp(timestamp: 1634915704)] as [String : Any]
        let ratesDictionary = ["rates": rateDictionary] as [String : Any]
        let dictionary = ["code": 200.0, "rates": ratesDictionary] as [String : Any]
        manager.writePlist(namePlist: "Exchange", key: "result", data: dictionary as AnyObject)
    }
    
    //Save data in the Exchange plist
    func readSavedModel()
    {
        print(manager.readPlist(namePlist: "Exchange", key: "rates"))
    }
    
    //Deletes data in the Exchange plist
    func deleteSavedModel()
    {
        manager.deleteAllData()
    }
    
    
  

}
