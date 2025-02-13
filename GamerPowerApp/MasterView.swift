//
//  ContentView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 11/02/2025.
//

import SwiftUI

struct MasterView: View {
    @StateObject private var viewModel = MasterViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    Text("👋 Hello, User")
                        .font(.headline)
                    Text("Explore\nGames Giveaways")
                        .font(.largeTitle.bold())
                }

                // Search Bar
                TextField("Search Game by name", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Filter Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.uniquePlatforms, id: \.self) { platform in
                            Text(platform)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Capsule())
                                .onTapGesture {
//                                    viewModel.selectedCategory = category
                                    viewModel.fetchGiveaways(platform: platform) // Fetch new giveaways
                                }
                        }
                    }
                }

                // Epic Games Carousel
                if !viewModel.epicGamesGiveaways.isEmpty {
                    CarouselView(items: viewModel.epicGamesGiveaways)
                        .frame(height: 200)
                        .padding(.vertical, 10)
                }

                // List of Giveaways
                ForEach(viewModel.filteredGiveaways, id: \.id) { giveaway in
                    GiveawayCardView(giveAway: giveaway)
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchGiveaways()
        }
    }
}

// Giveaway Item Card
struct GiveawayCardView: View {
    let giveAway: GiveAwayModel

    var body: some View {
        ZStack(alignment: .leading) {
            VStack() {
                AsyncImage(url: URL(string: giveAway.image ?? "")) { image in
                    image
                        .resizable()
                        .cornerRadius(25)
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                        .frame(height: UIScreen.main.bounds.height * 0.45)
                        .cornerRadius(25)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 32, height: 300)

            VStack(alignment: .leading) {
                
                HStack(alignment: .top) {
                    
                    //Title (Top Left)
                    Text(giveAway.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                      Button(action: {
//                          isFavorite.toggle()
//                          handleFavoriteAction()
                      }) {
                          Image(systemName: true ? "heart.fill" : "heart")
                              .foregroundColor(true ? .red : .white)
                              .padding(10)
                              .background(Color.black.opacity(0.6))
                              .clipShape(Circle())
                      }
                }
                
                Spacer()
                
                Text(giveAway.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(4)
                    .background(Color.black.opacity(0.5))  // Add slight background for readability
                    .cornerRadius(8)
            }
            .padding()
        }
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .background(.yellow)

    }
}

// Carousel View
struct CarouselView: View {
    let items: [GiveAwayModel]

    var body: some View {
        TabView {
            ForEach(items, id: \.id) { item in
                AsyncImage(url: URL(string: item.image ?? ""))
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .rotationEffect(.degrees(-5))
                    .animation(.easeInOut, value: item.id)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}
