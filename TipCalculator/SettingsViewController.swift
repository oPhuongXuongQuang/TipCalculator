//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Quang Phuong on 6/28/16.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var defaultPer: UITextField!
    @IBOutlet var minTip: UITextField!
    @IBOutlet var maxTip: UITextField!
    @IBOutlet var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                 style: UIBarButtonItemStyle.Plain,
                                                                 target: self,
                                                                 action: #selector(SettingsViewController.save))
        self.navigationItem.rightBarButtonItem?.enabled = false
        errorMessage.text = ""
        
        // Load Settings
        let defaults = NSUserDefaults.standardUserDefaults()
        let settings = defaults.objectForKey("Settings")
        if settings != nil {
            if let data = settings as? NSData {
                let settingObj = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SettingModel
                defaultPer.text = String(settingObj.defaultPercentage)
                minTip.text = String(settingObj.minTip)
                maxTip.text = String(settingObj.maxTip)
            }
        } else {
            defaultPer.text = "6"
            minTip.text = "0"
            maxTip.text = "100"
            save()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func save() {
        if validate() {
            let settingObj = SettingModel(defaultPer: Float(defaultPer.text!)!, min: Float(minTip.text!)!, max: Float(maxTip.text!)!)
            let saveObj = NSKeyedArchiver.archivedDataWithRootObject(settingObj)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(saveObj, forKey: "Settings")
            defaults.synchronize()
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    func validate() -> Bool {
        if defaultPer.text == "" || minTip.text == "" || maxTip.text == ""  {
            errorMessage.text = "Please input your number"
            return false
        }
        
        if Float(minTip.text!)! < 0 {
            errorMessage.text = "Min tip value must be > 0"
            return false
        }
        
        if Float(maxTip.text!)! < 0 {
            errorMessage.text = "Max tip value must be > 0"
            return false
        }
        
        if Float(maxTip.text!) <= Float(minTip.text!) {
            errorMessage.text = "Max tip value must be > Min tip value"
            return false
        }
        
        if Float(defaultPer.text!)! < Float(minTip.text!) || Float(defaultPer.text!)! > Float(maxTip.text!) {
            errorMessage.text = "Default percentage value must between " + minTip.text! + " and " + maxTip.text!
            return false
        }
        errorMessage.text = ""
        return true
    }
    
    @IBAction func textEditing() {
        if !self.navigationItem.rightBarButtonItem!.enabled {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
}
