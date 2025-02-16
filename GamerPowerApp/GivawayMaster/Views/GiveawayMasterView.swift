//
//  ContentView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 11/02/2025.
//

import SwiftUI

struct GiveawayMasterView: View {
    @StateObject private var viewModel = GiveawayMasterViewModel()
    @State private var isShowingCategories = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Headers
                    headerView
                    
                    // Search Bar
                    searchBarView
                    
                    // Filter Categories (Now Separate View)
                    PlatformFilterView(viewModel: viewModel, isShowingCategories: $isShowingCategories)
                    
                    // List of Giveaways
                    giveawayList
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchGiveaways()
            }
        }
    }
    
    // Extracted Header View
    private var headerView: some View {
        VStack(alignment: .leading) {
            Text("👋 Hello, User")
                .font(.headline)
            Text("Explore\nGames Giveaways")
                .font(.largeTitle.bold())
        }
    }
    
    // Extracted Search Bar View
    private var searchBarView: some View {
        TextField("Search Game by name", text: $viewModel.searchText)
            .padding(8)
            .background(Color.gray.opacity(0.2)) // Light gray background
            .cornerRadius(8) // Rounded corners
            .foregroundColor(.primary) // Ensure text is visible on gray background
            
            .overlay(
                HStack {
                    Spacer()
                    if !viewModel.searchText.isEmpty {
                        Button(action: { viewModel.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
            )
            .submitLabel(.done)
    }
    
    // Extracted Giveaway List View
    private var giveawayList: some View {
        ForEach(viewModel.filteredGiveaways, id: \.id) { giveaway in
            NavigationLink(destination: GiveawayDetailView(giveaway: giveaway, viewModel: viewModel)) {
                GiveawayCardView(giveaway: giveaway, viewModel: viewModel)
            }
        }
    }
}
