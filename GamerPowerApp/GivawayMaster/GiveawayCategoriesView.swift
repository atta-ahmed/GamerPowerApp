//
//  GiveawayCategoriesView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 15/02/2025.
//

import SwiftUI

struct GiveawayCategoriesView: View {
    @ObservedObject var viewModel: GiveawayMasterViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    backButton
                    titleSection
                    epicGamesCarousel
                    categorySections
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var backButton: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                    Text("Back")
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var titleSection: some View {
        Text("Categories")
            .font(.largeTitle.bold())
            .padding(.horizontal)
    }
    
    private var epicGamesCarousel: some View {
        Group {
            if !viewModel.epicGamesGiveaways.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.epicGamesGiveaways) { giveaway in
                            GiveawayCardView(giveaway: giveaway, viewModel: viewModel)
                                .frame(width: 300, height: 150)
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var categorySections: some View {
        VStack {
            ForEach(Array(viewModel.platformCategories.keys.sorted()), id: \.self) { platform in
                if let giveaways = viewModel.platformCategories[platform], !giveaways.isEmpty {
                    Section(header: Text(platform.uppercased())
                        .font(.headline)
                        .padding(.horizontal)) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(giveaways) { giveaway in
                                GiveawayCardView(giveaway: giveaway, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

extension GiveawayMasterViewModel {
    var platformCategories: [String: [GiveawayModel]] {
        Dictionary(grouping: giveaways) { giveaway in
            giveaway.platforms?.lowercased() ?? ""
        }
    }
}
