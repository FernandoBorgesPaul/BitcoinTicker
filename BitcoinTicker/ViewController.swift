

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var currencySymbolsArray = ["$", "R$", "$", "•", "Ä", "£", "$", "Rp", "?", "?", "•", "$", "kr", "$", "zl", "lei", "?", "kr", "$", "$", "R"]
    var selectedCurrency = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    //MARK: - Protocolos de composición del UIPicker
    
    //Determinamos Columnas
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Determinamos Filas que contendrá en UIPicker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //Determinamos los nombres que mostrará en cada row el UIPicker. Tomados del currencyArray.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //Determinamos que va a hacer el UIPicker con cada uno de los componentes de las filas al seleccionar cada una.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        selectedCurrency = currencySymbolsArray[row]
        getBitcoinData(url: finalURL)
    }
    

    //MARK: - Networking
    /***************************************************************/

    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }


    //MARK: - JSON Parsing
    /***************************************************************/

    func updateBitcoinData(json : JSON) {

        if let bitcoinResult = json["ask"].double {
         bitcoinPriceLabel.text = selectedCurrency+String(bitcoinResult)
        } else {
            bitcoinPriceLabel.text = "Price unavailable"
        }
        
    }

}

