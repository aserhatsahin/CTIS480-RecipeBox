//
//  FavoritesStore.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//

import Foundation

/// Favorileri recipe.id bazlı tutar.
final class FavoritesStore {

    static let shared = FavoritesStore()

    private init() {}

    private let key = "favorite_recipe_ids"

    /// Favori ID'leri set olarak döner.
    private var favoriteIDs: Set<Int> {
        get {
            let arr = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
            return Set(arr)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }

    /// İlgili recipe favori mi?
    func isFavorite(id: Int) -> Bool {
        favoriteIDs.contains(id)
    }

    /// Favori durumunu değiştirir (toggle).
    func toggleFavorite(id: Int) {
        var set = favoriteIDs
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
        favoriteIDs = set

        // Diğer ekranlar (Favorites tab vs.) için haber ver.
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }

    /// Tüm favori ID'leri
    func allFavoriteIDs() -> [Int] {
        Array(favoriteIDs)
    }
}

extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}
