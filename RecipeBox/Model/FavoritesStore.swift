//
//  FavoritesStore.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//

import UIKit
import CoreData

final class FavoritesStore {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private func fetchData() -> [FavoriteRecipe] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")

        do {
            let results = try context.fetch(fetchRequest)
            return results as! [FavoriteRecipe]
        } catch let error as NSError {
            print("Could not fetch favorites \(error), \(error.userInfo)")
            return []
        }
    }

    private func save() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save favorites \(error), \(error.userInfo)")
        }
    }

    func isFavorite(id: Int) -> Bool {
        let favorites = fetchData()
        return favorites.contains { Int($0.recipeId) == id }
    }

    func toggleFavorite(id: Int) {
        let favorites = fetchData()

        if let existing = favorites.first(where: { Int($0.recipeId) == id }) {
            context.delete(existing)
            save()
            return
        }

        let fav = FavoriteRecipe(context: context)
        fav.recipeId = Int64(id)
        save()
    }

    func getFavoriteIDs() -> [Int] {
        return fetchData().map { Int($0.recipeId) }
    }
}
