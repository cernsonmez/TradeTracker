//
//  TradeListView.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import SwiftUI
import Combine

struct TradeListView: View {
    @StateObject var vm = TradesViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    ScrollView {
                        LazyVStack {
                            ForEach(vm.dataToView) { trade in
                                TradeRowView(vm: vm, trade: trade)
                            }
                        }
                        .blur(radius: vm.showAddTrade ? 3 : 0)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            vm.showAddTrade.toggle()
                        }) {
                            Image(systemName:"magnifyingglass")
                                .foregroundColor(Color.orange)
                        }
                    }
                    ToolbarItem {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                vm.isEditMode.toggle()
                            }
                        }) {
                            Image(systemName: vm.isEditMode ? "pencil.circle.fill" : "pencil.circle")
                                .foregroundColor(Color.orange)
                        }
                    }
                }
                .navigationTitle("Your Trade Tracker")
                .font(.title)r
                .foregroundColor(Color.orange)
                .onAppear {
                    vm.fetch()
                }
                
                if vm.showAddTrade {
                    AddTradeSymbol(vm: vm)
                        .transition(.scale.animation(Animation.spring(response: 0.3)))
                }
            }
        }
    }
}

struct TradeListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TradeListView(vm: MockTradesViewModel())
            TradeListView(vm: MockTradesViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
