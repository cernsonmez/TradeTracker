//
//  BackgroundView.swift
//  TradeTracker
//
//  Created by Ceren on 6/4/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("BackgroundTop"), Color("BackgroundBottom")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BackgroundView()
            BackgroundView()
                .preferredColorScheme(.dark)
        }
    }
}
