//
//  ContentView.swift
//  CurrencyExchange
//
//  Created by lake on 10/18/21.
//

import SwiftUI

struct ContentView: View
{
     let dataModel = DataModel.sharedInstance
    let manager = PListManager()
    init()
    {
        UITextView.appearance().backgroundColor = .clear
        
    }
    
    @State private var fromCurrency = "USD"
    @State private var toCurrency = "USD"
    @State private var solution = ""
    
    @State private var currencies = ["USD", "EUR", "GBP"]
    
   
    
        var body: some View
        {
            GeometryReader
            { geometry in
    
                VStack
                {
                        Text("Currency Conversion")
                        .font(Font.largeTitle)
                        .foregroundColor(Color.green)
                        .fontWeight(.bold)
                        .onAppear {
                            
                            updateCurrency()
                        }
                        HStack
                        {
                                   Picker("From", selection: $fromCurrency)
                                   {
                                        ForEach(currencies, id: \.self)
                                        {
                                            if $0 == fromCurrency
                                            {
                                                Text(String($0))
                                                .foregroundColor(Color.green)
                                            }
                                            else
                                            {
                                                Text(String($0))
                                                .foregroundColor(Color.white)
                                            }
                                            
                                        }
                                        .font(.largeTitle)
                                    
                                    }
                                   .onChange(of: fromCurrency, perform: { newValue in
                                       solution = ""
                                       print("Changed")
                                   })
                                     .pickerStyle(.wheel)
                                     .frame(width: geometry.size.width / 2.0, height:geometry.size.height/4.0)
                                     .clipped()
                                    
                            
                            
                            
                                     Picker("Currency", selection: $toCurrency)
                                     {
                                         ForEach(currencies, id: \.self)
                                         {
                                             if $0 == toCurrency
                                             {
                                                 Text(String($0))
                                                 .foregroundColor(Color.yellow)
                                             }
                                             else
                                             {
                                             Text(String($0))
                                                 .foregroundColor(Color.white)
                                             }
                                             
                                         }
                                         .font(.largeTitle)
                                     }
                                     .onChange(of: toCurrency, perform: { newValue in
                                         solution = ""
                                     })
                                     .pickerStyle(.wheel)
                                     .frame(width: geometry.size.width / 2.0, height:geometry.size.height/4.0)
                                     .clipped()
                        }//end HStack
                    
                    // solution = "Conversion Rate\n" + fromCurrency + " to " + toCurrency
                    //print("load exchange")

                    Button(action:{})
                         {
                             let width = UIScreen.main.bounds.width
                             Text("Convert")
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .frame(minWidth: 0, maxWidth: width/2)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.green]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(30)
                             
                         }
                    
                    
                    Text(solution)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .font(.custom("Copperplate", size: 40))
                        .multilineTextAlignment(.center)
                        
                      
                    Spacer()
                }//end VStack
               
            }//end Geometry Reader
            
            .background(Color.black)
         
          
        }//end body
        
    
    func updateCurrency()
    {
        let currenciesDic = manager.readPlist(namePlist: "Currencies", key: "currencies")
        print("Hello:",currenciesDic.count)
        currencies = currenciesDic["currencies"] as! [String]
        
    }
   
    
    func loadRatesData()
    {
        let pair = toCurrency+fromCurrency
        let urlString = "https://www.freeforexapi.com/api/live?pairs="+pair
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data
            {
                     if let responseDecoder = try? JSONDecoder().decode(ExchangeRate.self, from: data)
                     {
                         DispatchQueue.main.async
                         {
                             print(responseDecoder)
                             print(responseDecoder.rates)
                             let resultDictionary: Dictionary<String, Dictionary<String, Double>> = responseDecoder.rates
                             let resultNSDictionary = resultDictionary as NSDictionary
                             print(resultNSDictionary)
                             
                         }
                     }
            }
        }.resume()
    }
    
    
    
}//end Content View

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
