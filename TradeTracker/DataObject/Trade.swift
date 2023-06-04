//
//  Trade.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import Foundation
struct Trade: Identifiable {
    let id = UUID()
    var symbol = ""
    var name = ""
    var formattedPrice = ""
    var formattedChange = ""
    var colorOfChange = "GreenColor"
}
