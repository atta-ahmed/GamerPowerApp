//
//  GiveawayDetailView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 13/02/2025.
//


import SwiftUI

struct GiveawayDetailView: View {
    let giveaway: GiveawayModel
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Giveaway Image with Favorite Button
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: giveaway.image ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 250)
                    }
                    
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .white)
                            .padding(10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .padding()
                    }
                }
                
                // Giveaway Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(giveaway.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let endDate = giveaway.endDate {
                        Text("🎯 Ends: \(endDate)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Text("🕹 Type: \(giveaway.type ?? "Unknown")")
                        .font(.subheadline)
                    
                    Text("👥 Players: \(giveaway.users ?? 0)")
                        .font(.subheadline)
                    
                    Divider()
                    
                    Text(giveaway.description ?? "No description available")
                        .font(.body)
                        .lineLimit(nil)
                    
                    if let urlString = giveaway.openGiveawayURL, let url = URL(string: urlString) {
                        Link(destination: url) {
                            Text("🎁 Claim Giveaway")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Giveaway Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
