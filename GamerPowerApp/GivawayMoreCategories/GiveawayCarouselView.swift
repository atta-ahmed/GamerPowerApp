//
//  GiveawayCarouselView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 16/02/2025.
//

import SwiftUI
import Kingfisher

struct GiveawayCarouselView: View {
    let topGiveaways: [GiveawayUIModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header Title
            Text("Categories")
                .font(.title.bold())
                .padding(.leading, 16)
            
            TabView {
                ForEach(topGiveaways.prefix(5)) { giveaway in
                    GeometryReader { geometry in
                        ZStack {
                            KFImage(URL(string: giveaway.image ?? ""))
                                .resizable()
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                                                   startPoint: .bottom,
                                                   endPoint: .top)
                                )
                                .rotation3DEffect(
                                    Angle(degrees: -Double(geometry.frame(in: .global).minX) / 20), // Fold effect
                                    axis: (x: 0, y: 1, z: 0)
                                )
                            
                            VStack {
                                Spacer()
                                Text(giveaway.title)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                                    .padding()
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .padding()
        }
    }
}
