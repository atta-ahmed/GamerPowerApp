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
                        VStack() {
                        KFImage(URL(string: giveaway.image ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                    }
                    
                        VStack(alignment: .leading) {
                        // **Top Controls (Back & Favorite)**
                        HStack {
                            // Back Button (Left)
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            
//                            Spacer()
                            
                            // Favorite Button (Right)
                            Button(action: {
                                Task {
                                    await viewModel.toggleFavorite(giveaway.id)
                                }
                            }) {
                                Image(systemName: viewModel.Favorites(giveaway.id) ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.Favorites(giveaway.id) ? .red : .white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                        }
                        .background(.red)
                        
                        // **Bottom Section (Title & "Get it" Button)**
//                        Spacer()
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
//                        .padding()
                        .background(.yellow)
                    }
                    .background(.green)

                }
                // Giveaway Details
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        GiveawayInfoView(icon: "dollarsign.circle", text: "N/A")
                        GiveawayInfoView(icon: "person.2", text: "\(giveaway.users ?? 0)")
                        GiveawayInfoView(icon: "gamecontroller", text: giveaway.type ?? "Unknown")
                    }
                    
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
                .padding()
            }
        }
        .navigationBarHidden(true) // Hide default navigation bar
    }
}


struct GiveawayInfoView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
            Text(text)
                .font(.subheadline)
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
