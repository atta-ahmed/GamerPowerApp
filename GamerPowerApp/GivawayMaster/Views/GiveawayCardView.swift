//
//  GiveawayCardView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 16/02/2025.
//

import SwiftUI
import Kingfisher

// Giveaway Item Card
struct GiveawayCardView: View {
    let giveaway: GiveawayUIModel
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
                                viewModel.toggleFavorite(giveaway.id)
                      }) {
                          Image(systemName: viewModel.isFavorite(giveaway.id) ? "heart.fill" : "heart")
                              .foregroundColor(viewModel.isFavorite(giveaway.id) ? .red : .white)
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
