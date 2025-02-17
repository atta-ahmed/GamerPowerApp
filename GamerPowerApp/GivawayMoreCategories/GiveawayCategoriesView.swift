//
//  GiveawayGridView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 16/02/2025.
//


import SwiftUI
import Kingfisher

struct GiveawayCategoriesView: View {
    let groupedGiveaways: [String: [GiveawayUIModel]]
    let topGiveaways: [GiveawayUIModel]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Carousel at the Top
                if !topGiveaways.isEmpty {
                    GiveawayCarouselView(topGiveaways: topGiveaways)
                        .padding(.top)
                }
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(groupedGiveaways.keys.sorted(), id: \.self) { platform in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(platform)
                                .font(.title2.bold())
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(groupedGiveaways[platform] ?? []) { giveaway in
                                        CardView(giveaway: giveaway)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
    }
}
