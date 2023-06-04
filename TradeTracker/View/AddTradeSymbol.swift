//
//  AddTradeSymbol.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import SwiftUI

struct AddTradeSymbol: View {
    @ObservedObject var vm: TradesViewModel
    @State private var symbol = ""
    @State private var symbolMissing = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                Text("Enter Trade Symbol")
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 26)
                Button(action: { vm.showAddTrade.toggle() }) {
                    Image(systemName: "x.circle")
                }
            }
            .font(.title2)
            
            Divider()
            
            TextField("Trade Symbol", text: $symbol)
                .autocapitalization(.allCharacters)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8)
                                .fill(Color.secondary.opacity(0.2))
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(symbolMissing ? Color.red : Color.clear, lineWidth: 1)))
            Button(action: {
                symbolMissing = symbol.isEmpty
                
                if symbolMissing == false {
                    vm.add(tradeSymbol: symbol)
                }
            }, label: {
                Text("Add")
                    .padding(8)
                    .padding(.horizontal, 40)
                    .background(Capsule().stroke(lineWidth: 1))
            })
            
            if vm.message.isEmpty == false {
                Text(vm.message)
                    .foregroundColor(Color.red)
                    .font(.footnote)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20)
                        .fill(.thinMaterial))
        .foregroundColor(Color.orange)
        .padding(.horizontal)
    }
}

struct AddTradeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        AddTradeSymbol(vm: MockTradesViewModel())
    }
}
