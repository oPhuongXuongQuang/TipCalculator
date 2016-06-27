//
//  ViewController.swift
//  TipCalculator
//
//  Created by Quang Phuong on 6/24/16.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var totalTextField : UITextField!
    @IBOutlet var taxPctSlider : UISlider!
    @IBOutlet var taxPctLabel : UILabel!
    @IBOutlet var tipAmountLabel : UILabel!
    @IBOutlet var plusResultLabel : UILabel!
    @IBOutlet var subResultLabel : UILabel!

    let tipCalc = TipCalculatorModel(total: 33.25, taxPct: 0.06)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        totalTextField.becomeFirstResponder()
        // Load Settings
        let defaults = NSUserDefaults.standardUserDefaults()
        let settings = defaults.objectForKey("Settings")
        if settings != nil {
            if let data = settings as? NSData {
                let settingObj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SettingModel
                taxPctSlider.value = settingObj.defaultPercentage
                tipCalc.taxPct = Double(settingObj.defaultPercentage)
                taxPctSlider.minimumValue = settingObj.minTip
                taxPctSlider.maximumValue = settingObj.maxTip
            }
        }
        
        // Load Total
        let dateData = defaults.objectForKey("Date")
        if dateData != nil {
            let oldDate = dateData as! NSDate
            let distance = oldDate.timeIntervalSinceDate(NSDate()) / 60
            if abs(distance) > 10 {
                defaults.removeObjectForKey("Date")
                defaults.synchronize()
            } else {
                totalTextField.text = defaults.objectForKey("Total") as! NSString as String
            }
        }
        refreshUI()
        calculateTip()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload settings
        let defaults = NSUserDefaults.standardUserDefaults()
        let settings = defaults.objectForKey("Settings")
        if settings != nil {
            if let data = settings as? NSData {
                let settingObj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SettingModel
                taxPctSlider.minimumValue = settingObj.minTip
                taxPctSlider.maximumValue = settingObj.maxTip
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshUI() {
        calculateTipAmount()
        taxPctLabel.text = "Tip (\(String(format: "%.2f", Float(taxPctSlider.value)))%)"
    }

    func calculateTipAmount() {
        let tipAmount = tipCalc.total * tipCalc.taxPct
        tipAmountLabel.text = formatCurrency(Float(tipAmount))
    }

    func calculateTip() {
        tipCalc.total = Double((totalTextField.text! as NSString).doubleValue)
        let plusResult = tipCalc.total + tipCalc.total * tipCalc.taxPct
        let subResult = tipCalc.total - tipCalc.total * tipCalc.taxPct
        
        plusResultLabel.text = formatCurrency(Float(plusResult))
        subResultLabel.text = formatCurrency(Float(subResult))
    }
    
    func formatCurrency(value: Float) -> String {
        let num = NSNumber(float: value)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(num)!
    }

    @IBAction func taxPercentageChanged(sender : AnyObject) {
        tipCalc.taxPct = Double(taxPctSlider.value) / 100.0
        refreshUI()
        calculateTip()
    }

    @IBAction func viewTapped(sender : AnyObject) {
        totalTextField.resignFirstResponder()
    }

    @IBAction func tipIsEditing() {
        if totalTextField.text == "" {
            tipCalc.total = 0
        } else {
            tipCalc.total = Double(totalTextField.text!)!
        }
        calculateTipAmount()
        calculateTip()
    }

    @IBAction func saveTotal() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(totalTextField.text, forKey: "Total")
        defaults.setObject(NSDate(), forKey: "Date")
        defaults.synchronize()
    }
}

