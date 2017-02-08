//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Bobby Hamrick on 1/17/17.
//  Copyright © 2017 Bobby Hamrick. All rights reserved.
//
import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
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
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    
    //func fahrenheitFieldEditingChanged
    //function to set the fahrenheit value when the fahrenheit text field changes
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        if let text = textField.text, let number = numberFormatter.number(from: text){
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
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
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }else{
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentLocale = Locale.current
        let decimalSeperator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeperator = textField.text?.range(of: decimalSeperator)
        let replacementTextHasDecimalSeperator = string.range(of: decimalSeperator)
        
        if string.rangeOfCharacter(
            from: NSCharacterSet(charactersIn: "-0123456789.,").inverted) != nil {
            return false
        }
        
        if existingTextHasDecimalSeperator != nil, replacementTextHasDecimalSeperator != nil {
            return false
        }else{
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view")
        
        updateCelsiusLabel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let redColor = Double(arc4random_uniform(10) + 0)/10
        let greenColor = Double(arc4random_uniform(10) + 0)/10
        let blueColor = Double(arc4random_uniform(10) + 0)/10

        let color = UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: 1)
        
        self.view.backgroundColor = color
        
    }
}
