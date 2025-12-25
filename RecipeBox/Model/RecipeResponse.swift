//
//  RecipeResponse.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//

import Foundation


final class RecipeResponse {
    var recipes: [Recipe]

    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
}
