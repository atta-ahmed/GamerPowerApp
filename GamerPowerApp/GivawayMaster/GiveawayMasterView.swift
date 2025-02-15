//
//  ContentView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 11/02/2025.
//

import SwiftUI
import Kingfisher

struct GiveawayMasterView: View {
    @StateObject private var viewModel = GiveawayMasterViewModel()
    @State private var isShowingCategories = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Headers
                    VStack(alignment: .leading) {
                        Text("👋 Hello, User")
                            .font(.headline)
                        Text("Explore\nGames Giveaways")
                            .font(.largeTitle.bold())
                    }
                    
                    // Search Bar
                    TextField("Search Game by name", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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

                    // Filter Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.uniquePlatforms, id: \.self) { platform in
                                Text(platform)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .foregroundColor(viewModel.selectedPlatform == platform ? .black : .gray)
                                    .onTapGesture {
                                        if viewModel.selectedPlatform == platform  { return }
                                        viewModel.selectPlatform(platform)
                                        viewModel.fetchGiveaways(platform: platform)
                                    }
                            }
                            
                            Button(action: {
                                isShowingCategories = true
                            }) {
                                Text("more")
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .sheet(isPresented: $isShowingCategories) {
                                GiveawayCategoriesView(viewModel: viewModel)
                            }
                        }
                    }
                    
                    // List of Giveaways
                    ForEach(viewModel.filteredGiveaways, id: \.id) { giveaway in
                        NavigationLink(destination: GiveawayDetailView(giveaway: giveaway, viewModel: viewModel)) {
                            GiveawayCardView(giveaway: giveaway, viewModel: viewModel)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchGiveaways()
            }
        }
    }
}

// Giveaway Item Card
struct GiveawayCardView: View {
    let giveaway: GiveawayModel
    @ObservedObject var viewModel: GiveawayMasterViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            VStack() {
                KFImage(URL(string: giveaway.image ?? ""))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 300)
                    .cornerRadius(25)
                    .clipped()
            }

            VStack(alignment: .leading) {
                
                HStack(alignment: .top) {
                    
                    Text(giveaway.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                      Button(action: {
                          Task {
                                 await viewModel.toggleFavorite(giveaway.id)
                             }
                      }) {
                          Image(systemName: viewModel.isFave(giveaway.id) ? "heart.fill" : "heart")
                              .foregroundColor(viewModel.isFave(giveaway.id) ? .red : .white)
                              .padding(10)
                              .background(Color.black.opacity(0.6))
                              .clipShape(Circle())
                      }
                }
                
                Spacer()
                
                Text(giveaway.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
            }
            .padding()
        }
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

    }
}
