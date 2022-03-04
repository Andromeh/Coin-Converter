//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "6F848BD7-BA49-4320-B1EC-9EB17B3B8792"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice (for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString)

    }
        
    func performRequest (with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        delegate?.didUpdatePrice(self, price: price)
                    }
                    
                }
            
                    var dataAsString = String(data: data!, encoding: String.Encoding.utf8)

                    //print(dataAsString)
                    
                   
            }
            
            task.resume()
        }
    }
    
    func parseJSON (_ data: Data) -> String? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let priceString = String(format: "%0.0f", lastPrice)
            print(priceString)
            return priceString
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}

protocol CoinManagerDelegate {
    //func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    func didUpdatePrice(_ coinManager: CoinManager, price: String)

}

