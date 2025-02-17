//
//  CardView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 16/02/2025.
//

import SwiftUI
import Kingfisher

struct CardView: View {
    let giveaway: GiveawayUIModel

    var body: some View {
        ZStack {
            KFImage(URL(string: giveaway.image ?? ""))
                .resizable()
                .frame(width: 180, height: 120)
                .cornerRadius(10)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )

            Text(giveaway.title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 8)
                .frame(width: 180)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
