//
//  ViewController.swift
//  ByteCoin
//
//  Created by Anurag Kashyap on 29/11/2023.

//

import UIKit

class ViewController: UIViewController {
    //UIPickerViewDataSource protocol decides the various characteristics of the pricker view like no. of rows and columns
    //UIPickerViewDelegate protocol helps us scroll the picker view and get the data and some other general functions of the picker view
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }

}
//MARK: - UIPickerViewDataSource
extension ViewController : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //this method tell the picker view how many columns there should be in picker view (part of UIPickerViewDataSource protocol)
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //this method tell the picker view how many rows there should be in picker view (part of UIPickerViewDataSource protocol)
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //this method changes the picker view (part of UIPickerViewDelegate protocol)
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //this method keeps track of the row number of the picker view (part of UIPickerViewDelegate protocol)
        //print(row)
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate
extension ViewController : CoinManagerDelegate{
    func didUpdatePrice(_ coinManager : CoinManager , price : PriceModel){
            DispatchQueue.main.async{
                self.bitcoinLabel.text = String(format : "%0.3f" , price.priceOfBitcoin)
                self.currencyLabel.text = price.currency
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
