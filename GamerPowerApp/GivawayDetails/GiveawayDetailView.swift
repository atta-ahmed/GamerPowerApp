//
//  GiveawayDetailView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 13/02/2025.
//


import SwiftUI
import Kingfisher

struct GiveawayDetailView: View {
    let giveaway: GiveawayModel
    @ObservedObject var viewModel: GiveawayMasterViewModel
    @Environment(\.presentationMode) var presentationMode  // To handle back button

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Image Section with Overlays
                ZStack {
                    // Giveaway Image with Overlay
                    KFImage(URL(string: giveaway.image ?? ""))
                        .resizable()
                        .frame(maxWidth: .infinity) // Ensure it fills the screen
                        .frame(height: 300)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )

                    VStack {
                        // **Top Controls (Back & Favorite)**
                        HStack {
                            // Back Button
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()

                            // Favorite Button
                            Button(action: {
                                Task {
                                    await viewModel.toggleFavorite(giveaway.id)
                                }
                            }) {
                                Image(systemName: viewModel.isFavorites(giveaway.id) ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.isFavorites(giveaway.id) ? .red : .white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        
                        Spacer() // This pushes the bottom section down

                        // **Bottom Section (Title & "Get it" Button)**
                        HStack {
                            Text(giveaway.title)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .shadow(radius: 2)

                            Spacer()

                            if let urlString = giveaway.openGiveawayURL, let url = URL(string: urlString) {
                                Link(destination: url) {
                                    Text("Get it")
                                        .font(.headline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .clipShape(Capsule())
                                        .shadow(radius: 2)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                // Giveaway Details
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {

                        GiveawayInfoView(icon: "dollarsign.circle.fill", text: "N/A")
                        Divider()

                        GiveawayInfoView(icon: "person.2.fill", text: "\(giveaway.users ?? 0)")
                        Divider()

                        GiveawayInfoView(icon: "gamecontroller.fill", text: giveaway.type ?? "Unknown")
                    }
                    .frame(maxWidth: .infinity) // Make HStack expand to full width

                    Divider()
                    
                    Text("Platforms")
                        .font(.headline)
                    Text(giveaway.platforms ?? "Unknown")
                        .font(.subheadline)
                    
                    Text("Giveaway End Date")
                        .font(.headline)
                    Text(giveaway.endDate ?? "Unknown")
                        .font(.subheadline)
                    
                    Text("Description")
                        .font(.headline)
                    Text(giveaway.description ?? "No description available")
                        .font(.body)
                }
            }
        }
        .padding(30)

        .navigationBarHidden(true) // Hide default navigation bar
    }
}
