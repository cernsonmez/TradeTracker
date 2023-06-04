//
//  TradeInfo.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import Foundation
struct TradeInfo: Decodable {
    var symbol = ""
    var name = ""
    var price = 0.0
    var changesPercentage = 0.0
}
