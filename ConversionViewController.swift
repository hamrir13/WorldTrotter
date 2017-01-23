//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Bobby Hamrick on 1/17/17.
//  Copyright © 2017 Bobby Hamrick. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController{
    
    //declare a UILabel for the converted temperature
    @IBOutlet var celsiusLabel: UILabel!
    
    //declare variable for fahrenheit value
    var fahrenheitValue: Measurement<UnitTemperature>?{
        didSet {
            updateCelsiusLabel()
        }
    }
    
    //declare and compute value for celsius value
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue{
            return fahrenheitValue.converted(to: .celsius)
        }else{
            return nil
        }
    }
    
    //declare a UITextField for the degree text
    @IBOutlet var textField: UITextField!
    
    
    //func fahrenheitFieldEditingChanged
    //function to set the fahrenheit value when the fahrenheit text field changes
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        if let text = textField.text, let value = Double(text){
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        }else{
            fahrenheitValue = nil
        }
    }
    
    //func dismissKeyboard
    //function to dismiss the keyboard when user taps background
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
        textField.resignFirstResponder()
    }
    
    //func updateCelsiusLabel
    //function to update the celsius label whenever the
    //fahreheit value changes
    func updateCelsiusLabel(){
        if let celsiusValue = celsiusValue{
            celsiusLabel.text = "\(celsiusValue.value)"
        }else{
            celsiusLabel.text = "???"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCelsiusLabel()
    }
}
