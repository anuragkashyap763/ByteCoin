//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Anurag Kashyap on 29/11/2023.
//

import Foundation
protocol CoinManagerDelegate{
    func didUpdatePrice(_ coinManager : CoinManager , price : PriceModel)
    func didFailWithError(error: Error)
}
let priceAPI = PriceAPI()
struct CoinManager {
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : CoinManagerDelegate?
    
    func getCoinPrice(for currency : String){
        let urlString = "\(priceAPI.baseURL)/\(currency)?apikey=\(priceAPI.apiKey)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString : String){
        //1.Create URL
        if let url = URL(string : urlString){
            //2.Create a URL Session
            let session = URLSession(configuration: .default)
            //3. Give a task to URLSession
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            //4.Start Task
            task.resume()
        }
    }
    func handle(data : Data? , response : URLResponse? , error : Error?){
        if error != nil{
            delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data{
            if let price = parseJSON(priceData: safeData){
                delegate?.didUpdatePrice(self , price : price)
            }
            
        }
    }
    
    func parseJSON(priceData : Data) -> PriceModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(PriceData.self, from: priceData)
            let currencyID = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let price = PriceModel(priceOfBitcoin: rate, currency:currencyID)
            return price
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
