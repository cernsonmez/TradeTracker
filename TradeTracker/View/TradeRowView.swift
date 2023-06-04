//
//  TradeRowView.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import SwiftUI

struct TradeRowView: View {
    @ObservedObject var vm: TradesViewModel
    let trade: Trade
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(trade.symbol)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(trade.name)
                    .font(.footnote)
            }
            VStack(alignment: .trailing) {
                Text(trade.formattedPrice)
                Text(trade.formattedChange)
                    .font(.footnote)
                    .foregroundColor(Color(trade.colorOfChange))
            }
            VStack(alignment: .trailing) {
                trade.colorOfChange == "GreenColor" ?
                Image(systemName: "arrow.up")
                    .foregroundColor(Color(trade.colorOfChange)) :
                Image(systemName: "arrow.down")
                    .foregroundColor(Color(trade.colorOfChange))
            }
            
            if vm.isEditMode {
                Button(action: {
                    withAnimation {
                        vm.delete(tradeToDelete: trade)
                    }
                }, label: {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .padding(.leading, 8)
                })
                .transition(.asymmetric(insertion: .scale.animation(Animation.easeOut(duration: 0.1).delay(0.2)),
                                        removal: .scale))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange.opacity(0.15)))
        .padding(.horizontal)
        .padding(.vertical, 4)
        .transition(.scale.animation(Animation.spring(response: 0.3))) // insertion/deletion animation
    }
}

struct TradeRowView_Previews: PreviewProvider {
    static var trade = Trade(symbol: "AAPL", name: "Apple Inc.", formattedPrice: "$127.10", formattedChange: "1.33%")
    
    static var previews: some View {
        TradeRowView(vm: MockTradesViewModel(), trade: trade)
            .previewLayout(.sizeThatFits)
    }
}
