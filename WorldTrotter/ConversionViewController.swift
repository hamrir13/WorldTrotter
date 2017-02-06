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
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }else{
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeperator = string.range(of: ".")
        
        if string.rangeOfCharacter(
            from: NSCharacterSet(charactersIn: "-0123456789.").inverted) != nil {
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
    
    func randomColorGenerator() -> Int{
        let randomColor = Int(arc4random_uniform(3))
        return randomColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backColor = [UIColor(red: 193/255, green: 176/255, blue: 81/255, alpha: 1),
                         UIColor(red: 193/255, green: 176/255, blue: 210/255, alpha: 1),
                         UIColor(red: 0/255, green: 176/255, blue: 210/255, alpha: 1),
                         UIColor(red: 255/255, green: 161/255, blue: 0/255, alpha: 1),
                         UIColor(red: 87/255, green: 141/255, blue: 155/255, alpha: 1)
        ]
        
        let ranNum = randomColorGenerator()
        let color = backColor[ranNum]
        
        self.view.backgroundColor = color
        
        
    }
}
