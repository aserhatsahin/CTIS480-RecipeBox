//
//  RecipesDataSource.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//

import Foundation

final class RecipesDataSource {

    private(set) var allRecipes: [Recipe] = []
    private(set) var visibleRecipes: [Recipe] = []

    func setRecipes(_ recipes: [Recipe]) {
        self.allRecipes = recipes
        self.visibleRecipes = recipes
    }

    func search(query: String) {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !q.isEmpty else {
            visibleRecipes = allRecipes
            return
        }

        visibleRecipes = allRecipes.filter { $0.title.lowercased().contains(q) }
    }
}
