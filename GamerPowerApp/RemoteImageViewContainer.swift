//
//  RemoteImageViewContainer 2.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 14/02/2025.
//


import SwiftUI

import SwiftUI

struct RemoteImageViewContainer: View {
    var imageURL: URL
    var width: CGFloat?
    var height: CGFloat?
    var placeholder: Image
    var borderColor: Color
    var borderWidth: CGFloat
    var cornerRadius: CGFloat

    init(
        imageURL: URL,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        placeholder: Image = Image(systemName: "photo"),
        borderColor: Color = Color.gray.opacity(0.5),
        borderWidth: CGFloat = 0,
        cornerRadius: CGFloat = 0
    ) {
        self.imageURL = imageURL
        self.width = width
        self.height = height
        self.placeholder = placeholder
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RemoteImageView(
            url: imageURL,
            placeholder: {
                placeholder
            },
            image: { image in
                image
            }
        )
        .frame(width: width ?? UIScreen.main.bounds.width - 24, height: height ?? 180)
        .clipped()
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }
}

struct RemoteImageView: View {
    let url: URL
    let placeholder: () -> Image
    let image: (Image) -> Image

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let uiImage):
                uiImage
            case .failure:
                placeholder()
            case .empty:
                placeholder()
            @unknown default:
                placeholder()
            }
        }
    }
}



