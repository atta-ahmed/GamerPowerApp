//
//  PlatformFilterView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 16/02/2025.
//

import SwiftUI

struct PlatformFilterView: View {
    @ObservedObject var viewModel: GiveawayMasterViewModel
    @Binding var isShowingCategories: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.uniquePlatforms, id: \.self) { platform in
                    Text(platform.rawValue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundColor(viewModel.selectedPlatform == platform ? .black : .gray)
                        .onTapGesture {
                            if viewModel.selectedPlatform == platform { return }
                            viewModel.selectPlatform(platform)
                            viewModel.fetchGiveaways(platform: platform)
                        }
                }

                NavigationLink(destination: GiveawayCategoriesView(groupedGiveaways: viewModel.groupGiveawaysByPlatform(), topGiveaways: viewModel.giveaways)) {
                    Text("More")
                        .foregroundColor(.blue)
                        .underline()
                }
            }
        }
    }
}
