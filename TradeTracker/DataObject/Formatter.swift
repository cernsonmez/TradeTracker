//
//  Formatter.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import Foundation

class Formatter {
    class func getPrice(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: number)) ?? "N/A"
    }
    
    class func getPercent(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: number/100)) ?? "N/A"
    }
}
