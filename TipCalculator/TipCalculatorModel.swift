//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Quang Phuong on 6/24/16.
//

import Foundation

class TipCalculatorModel {

  var total: Double
  var taxPct: Double
  
  init(total: Double, taxPct: Double) {
    self.total = total
    self.taxPct = taxPct
  }
}