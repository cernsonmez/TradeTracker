//
//  TradesViewModel.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import Foundation
import SwiftUI
import Combine

struct TradeError: Error {
    var symbol = ""
}

class TradesViewModel: ObservableObject {
    @AppStorage("Trades") var trades = "AAPL,FB"
    @Published var dataToView: [Trade] = []
    @Published var message = ""
    @Published var showAddTrade = false
    @Published var isEditMode = false
    private var noTradeFound = "No trade found"
    var tradeSymbols: [String] = []
    var cancellables: Set<AnyCancellable> = []

    let urlString = "https://financialmodelingprep.com/api/v3/quote/{0}?apikey=\(AppViewModel.apiKey)"
    
    init() {
        // Get data from the @AppStorage and convert it into an array
        if trades.last == "," {
            trades.removeLast()
        }
        tradeSymbols = trades.components(separatedBy: ",")
    }

    func fetch() {
        tradeSymbols.publisher
            .map { tradeSymbol -> (URL, String) in
                let newURLString = urlString.replacingOccurrences(of: "{0}", with: tradeSymbol)
                let url = URL(string: newURLString)!
                return (url, tradeSymbol)
            }
            .flatMap { [unowned self] (url, symbol) in
                // Start a new publisher for each symbol
                getTradeInfo(url: url, symbol: symbol)
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [unowned self] trade in
                dataToView.append(trade)
            })
            .store(in: &cancellables)
    }
    
    func add(tradeSymbol: String) {
        // Make sure the symbol doesn't already exist
        if tradeSymbols.contains(tradeSymbol) {
            message = "Trade already added"
            return
        } else {
            tradeSymbols.append(tradeSymbol)
            // Save the new symbol to @AppStorage
            trades = tradeSymbols.joined(separator: ",")
        }
        
        let newURL = urlString.replacingOccurrences(of: "{0}", with: tradeSymbol)
    
        getTradeInfo(url: URL(string: newURL)!, symbol: tradeSymbol)
            .receive(on: RunLoop.main)
            .sink { [unowned self] trade in
                if trade.name == noTradeFound {
                    message = noTradeFound
                } else {
                    message = ""
                    showAddTrade = false
                    dataToView.append(trade)
                }
            }
            .store(in: &cancellables)
    }
    
    func getTradeInfo(url: URL, symbol: String) -> AnyPublisher<Trade, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data: Data, response: URLResponse) in
                data // Just return the data
            }
            .decode(type: [TradeInfo].self, decoder: JSONDecoder())
            .tryMap { tradeArray -> Trade in
                if tradeArray.isEmpty {
                    throw TradeError()
                }
                
                let trade = tradeArray[0]
                
                return Trade(symbol: trade.symbol, name: trade.name,
                             formattedPrice: Formatter.getPrice(trade.price),
                             formattedChange: Formatter.getPercent(trade.changesPercentage),
                             colorOfChange: trade.changesPercentage < 0 ? "RedColor" : "GreenColor")
            }
            .replaceError(with: Trade(symbol: symbol, name: noTradeFound))
            .eraseToAnyPublisher()
    }
    
    func delete(tradeToDelete: Trade) {
        // Remove from cache
        if let index = dataToView.firstIndex(where: { $0.id == tradeToDelete.id }) {
            dataToView.remove(at: index)
        }
        
        // Remove from array of symbols
        if let index = tradeSymbols.firstIndex(where: { $0 == tradeToDelete.symbol }) {
            tradeSymbols.remove(at: index)
        }

        // Save updated tradeSymbols array to @AppStorage
        trades = tradeSymbols.joined(separator: ",")
    }
}

class MockTradesViewModel: TradesViewModel {
    override func fetch() {
        dataToView.append(Trade(symbol: "AAPL", name: "Apple Inc.",
                                formattedPrice: Formatter.getPrice(127.1),
                                formattedChange: Formatter.getPercent(1.33)))
        dataToView.append(Trade(symbol: "TSLA", name: "Tesla Inc.",
                                formattedPrice: Formatter.getPrice(606.44),
                                formattedChange: Formatter.getPercent(4.4)))
        dataToView.append(Trade(symbol: "SBUX", name: "Starbucks Coffee Company",
                                formattedPrice: Formatter.getPrice(112.63),
                                formattedChange: Formatter.getPercent(0.11)))
        dataToView.append(Trade(symbol: "KO", name: "The Coca-Cola Company",
                                formattedPrice: Formatter.getPrice(50.45),
                                formattedChange: Formatter.getPercent(-0.01),
                                colorOfChange: "RedColor"))
        dataToView.append(Trade(symbol: "MSFT", name: "Microsoft Corporation",
                                formattedPrice: Formatter.getPrice(251.72),
                                formattedChange: Formatter.getPercent(0.94)))
    }
}
