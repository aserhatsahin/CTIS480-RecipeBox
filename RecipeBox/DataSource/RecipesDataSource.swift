//
//  RecipesDataSource.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//

import Foundation
import SwiftyJSON

final class RecipesDataSource {
    var recipes: [Recipe] = []

    func populateFromJSON() {
        recipes.removeAll()

        let urlString = "https://raw.githubusercontent.com/aserhatsahin/CTIS480-RecipeBox/refs/heads/develop/recipes.json"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {

                guard let json = try? JSON(data: data) else {
                    print("JSON parse error")
                    return
                }

                for i in 0..<json["recipes"].count {
                    let recipeJSON = json["recipes"][i]
                    let recipe = Recipe(json: recipeJSON)
                    recipes.append(recipe)
                }

            } else {
                print("Data download error")
            }
        }
    }
}
