//
//  GiveawayInfoView.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 16/02/2025.
//

import SwiftUI

struct GiveawayInfoView: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.black)
            Text(text)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
