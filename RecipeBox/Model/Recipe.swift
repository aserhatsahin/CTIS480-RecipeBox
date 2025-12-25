//
//  Recipe.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//

import Foundation

final class Recipe {
    let id: String
    let title: String
    let category: String
    let durationMinutes: Int
    let imageName: String
    let summary: String
    let ingredients: [String]
    let steps: [String]
    
    init(
        id: String,
        title: String,
        category: String,
        durationMinutes: Int,
        imageName: String,
        summary: String,
        ingredients: [String],
        steps: [String]
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.durationMinutes = durationMinutes
        self.imageName = imageName
        self.summary = summary
        self.ingredients = ingredients
        self.steps = steps
    }
}
