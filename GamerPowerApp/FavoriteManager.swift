//
//  FavoriteManager.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 13/02/2025.
//

import Foundation
actor FavoriteManager {
    static let shared = FavoriteManager()

    private var favorites: Set<String> = []
    private let userDefaultsKey = "favoriteGiveaways"

    init() {
        Task {
            await loadFavorites()
        }
    }

    private func loadFavorites() async {
        let storedFavorites = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        favorites = Set(storedFavorites)
        print("loadFavorites favorites: \(favorites)")
    }

    func getFavoriteIDs() async -> Set<String> {
        return favorites
    }

    func isFavorite(_ id: String) -> Bool {
        return favorites.contains(id)
    }

    func toggleFavorite(_ id: String) async {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        await saveFavorites()
    }

    private func saveFavorites() async {
        let favoriteArray = Array(favorites)
        UserDefaults.standard.set(favoriteArray, forKey: userDefaultsKey)
        print("saveFavorites favorites: \(favoriteArray)")
    }
}



