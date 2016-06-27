//
//  SettingModel.swift
//  TipCalculator
//
//  Created by Quang Phuong on 6/28/16.
//

import Foundation

class SettingModel: NSObject {
    var defaultPercentage: Float
    var minTip: Float
    var maxTip: Float
    
    init(defaultPer: Float,min: Float,max: Float) {
        defaultPercentage = defaultPer
        minTip = min
        maxTip = max
    }
    
    required init(coder aDecoder: NSCoder) {
        self.defaultPercentage = (aDecoder.decodeObjectForKey("defaultPercentage") as? Float)!
        self.minTip = (aDecoder.decodeObjectForKey("minTip") as? Float)!
        self.maxTip = (aDecoder.decodeObjectForKey("maxTip") as? Float)!
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.defaultPercentage, forKey: "defaultPercentage")
        aCoder.encodeObject(self.minTip, forKey: "minTip")
        aCoder.encodeObject(self.maxTip, forKey: "maxTip")
    }
}