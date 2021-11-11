//
//  ContentView.swift
//  CurrencyExchange
//
//  Created by lake on 10/18/21.
//

import SwiftUI
import BetterSafariView

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
    @State private var rate = 0.0
    @State private var rate2 = 0.0
    @State private var currencies = ["USD", "EUR", "GBP"]
    @State private var amountCurrency = 1.0
    @State private var histArray = [Dictionary<String,String>]()
    @State private var histStringArray = [""]
    @State private var myTimestamp = 0.0
    @State private var isEditing = false
    @State private var checkurl = "https://www.google.com/search?q=USD+to+CNY"
    @State private var presentingSafariView = false
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
                        
                            TextField("Search ...", text: $toCurrency)
                                        .padding(7)
                                        .padding(.horizontal, 25)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .padding(.horizontal, 10)
                                        
                                    if isEditing {
                                        Button(action: {
                                            self.isEditing = false
                                            self.toCurrency = ""
                         
                                        }) {
                                            Text("Cancel")
                                        }
                                        .padding(.trailing, 10)
                                        .transition(.move(edge: .trailing))
                                        .animation(.default)
                                    }
                            Button(action:{
                                var temp = toCurrency
                                toCurrency = fromCurrency
                                fromCurrency = temp
                            }){
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                            
                            TextField("Search ...", text: $fromCurrency)
                                        .padding(7)
                                        .padding(.horizontal, 25)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .padding(.horizontal, 10)
                                        
                                    if isEditing {
                                        Button(action: {
                                            self.isEditing = false
                                            self.toCurrency = ""
                         
                                        }) {
                                            Text("Cancel")
                                        }
                                        .padding(.trailing, 10)
                                        .transition(.move(edge: .trailing))
                                        .animation(.default)
                                    }
                        }
                        HStack
                        {
                            TextField("Search ...", value: $amountCurrency, formatter: NumberFormatter())
                                        .padding(7)
                                        .padding(.horizontal, 25)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .padding(.horizontal, 10)
                                        
                                    if isEditing {
                                        Button(action: {
                                            self.isEditing = false
                                            self.toCurrency = ""
                         
                                        }) {
                                            Text("Cancel")
                                        }
                                        .padding(.trailing, 10)
                                        .transition(.move(edge: .trailing))
                                        .animation(.default)
                                    }
                            
                            
                        }
                        HStack
                        {
                            
                           
                            
                                   Picker("From", selection: $toCurrency)
                                   {
                                        ForEach(currencies, id: \.self)
                                        {
                                            if $0 == toCurrency
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
                                   .onChange(of: toCurrency, perform: { newValue in
                                       solution = ""
                                       print("Changed")
                                   })
                                     .pickerStyle(.wheel)
                                     .frame(width: geometry.size.width / 2.0, height:geometry.size.height/4.0)
                                     .clipped()
                                    
                            
                            
                            
                                     Picker("Currency", selection: $fromCurrency)
                                     {
                                         ForEach(currencies, id: \.self)
                                         {
                                             if $0 == fromCurrency
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
                                     .onChange(of: fromCurrency, perform: { newValue in
                                         solution = ""
                                     })
                                     .pickerStyle(.wheel)
                                     .frame(width: geometry.size.width / 2.0, height:geometry.size.height/4.0)
                                     .clipped()
                        }//end HStack
                    
                    // solution = "Conversion Rate\n" + fromCurrency + " to " + toCurrency
                    //print("load exchange")
                    HStack
                    {
                        Button(action:{
                            histStringArray = []
                            checkurl = "https://www.google.com/search?q="+String(amountCurrency)+toCurrency+"+to+"+fromCurrency
                            dataModel.getCurrencies()
                            //print(dataModel.currencies)
                            print("Conversion Rate\n" + fromCurrency + " to " + toCurrency)
                            solution = ""
                            loadRatesData()
                            
                            
                        })
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
                        Button(action:{
                            
                            let readFromPlist = manager.readPlist(namePlist: "History", key: "history")
                           
                            let histDict = readFromPlist as! [Dictionary<String,String>]
                            for histsearch in histDict{
                                histStringArray.append(histsearch["solution"] ?? "")
                            }
                            histStringArray.removeFirst()
                            
                            
                        })
                             {
                                 let width = UIScreen.main.bounds.width
                                 Text("History")
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .frame(minWidth: 0, maxWidth: width/2)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(LinearGradient(gradient: Gradient(colors: [Color.red]), startPoint: .leading, endPoint: .trailing))
                                        .cornerRadius(30)
                                 
                             }
                        
                        
                        
                    }
                    Text(solution)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .font(.custom("Copperplate", size: 35))
                        .multilineTextAlignment(.center)
                        
                      
                    Spacer()
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(histStringArray.reversed(),id:\.self) { element in
                                Text(element)
                                    .foregroundColor(.white)
                                    .font(.custom("Copperplate", size: 30))
                                    .frame(width: 400, height: 125)
                                    .background(Color.red)
                            }
                        }
                    }
                    .frame(height: 200)
                    
                    
                    Button(action: {
                               self.presentingSafariView = true
                        
                        
                           }) {
                               Text("Check with google?")
                                   .font(.title)
                               
                           }
                           .safariView(isPresented: $presentingSafariView) {
                               SafariView(
                                   url: URL(string: checkurl)!,
                                   configuration: SafariView.Configuration(
                                       entersReaderIfAvailable: false,
                                       barCollapsingEnabled: true
                                   )
                               )
                               .preferredBarAccentColor(.clear)
                               .preferredControlAccentColor(.accentColor)
                               .dismissButtonStyle(.done)
                           }
                }//end VStack
               
            }//end Geometry Reader
            
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            
        //
          
        }//end body
        
    
    func updateCurrency()
    {
        let currenciesDic = manager.readPlist(namePlist: "Currencies", key: "currencies")
        //print("Hello:",currenciesDic.count)
        currencies = currenciesDic["currencies"] as! [String]
        
    }
   
    func connectURLSession(mode:Int,getPair:String)
    {
        var pair:String = getPair
        if(mode == 2)
        {
            pair = fromCurrency + toCurrency
        }
        let urlString = "https://www.freeforexapi.com/api/live?pairs=" + pair
        
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
                             myTimestamp = responseDecoder.rates[pair]!["timestamp"]!
                             
                             let resultDictionary: Dictionary<String, Dictionary<String, Double>> = responseDecoder.rates
                             rate = responseDecoder.rates[pair]!["rate"]!
                             if(mode == 2){rate = 1/rate}
                             solution += String(amountCurrency) + " " + toCurrency + String(" is ") + "\n"
                             let res = rate * amountCurrency
                             solution += String(format: "%.5f ",res)
                             solution += fromCurrency
                             solution += "\n"
                             
                             solution += dataModel.convertTimeStamp(timestamp: myTimestamp - (3600*5))
                             solution += "\n"
                             //let resultNSDictionary = resultDictionary as NSDictionary
                             //print(resultNSDictionary)
                             histArray += [["timestamp":String(myTimestamp),"solution":solution]]
                             manager.writePlist(namePlist: "History", key: "history", data: histArray as AnyObject)
                         }
                     }else{solution += "Sorry, the converstion rate is unavailable now."}
            }
           
        }.resume()
    }
    func loadRatesData()
    {
        let pair = toCurrency+fromCurrency
        
        if(dataModel.isPair(requestPair: pair))
        {
            connectURLSession(mode: 1, getPair: pair)
        }
        else if(dataModel.isPair(requestPair: fromCurrency+toCurrency))
        {
            connectURLSession(mode: 2, getPair: pair)
        }
        else if(dataModel.isPair(requestPair: "USD"+toCurrency) && dataModel.isPair(requestPair: "USD"+fromCurrency))
        {
            let urlString = "https://www.freeforexapi.com/api/live?pairs=" + "USD" + toCurrency + "," + "USD" + fromCurrency
            
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
                                 myTimestamp = responseDecoder.rates["USD"+fromCurrency]!["timestamp"]!
                                 
                                 let resultDictionary: Dictionary<String, Dictionary<String, Double>> = responseDecoder.rates
                                 rate = responseDecoder.rates["USD"+fromCurrency]!["rate"]!
                                 rate2 = responseDecoder.rates["USD"+toCurrency]!["rate"]!
                                 rate = rate/rate2
                                 solution += String(amountCurrency) + " " + toCurrency + String(" is ") + "\n"
                                 let res = rate * amountCurrency
                                 solution += String(format: "%.5f ",res)
                                 solution += fromCurrency
                                 solution += "\n"
                                 
                                 solution += dataModel.convertTimeStamp(timestamp: myTimestamp - (3600*5))
                                 solution += "\n"
                                 //let resultNSDictionary = resultDictionary as NSDictionary
                                 //print(resultNSDictionary)
                                 histArray += [["timestamp":String(myTimestamp),"solution":solution]]
                                 manager.writePlist(namePlist: "History", key: "history", data: histArray as AnyObject)
                             }
                         }
                        else{solution += "Sorry, the converstion rate is unavailable now."}
                }
               
            }.resume()
        }
            
        
    }
        
        
        
       
    
    
    
}//end Content View

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
