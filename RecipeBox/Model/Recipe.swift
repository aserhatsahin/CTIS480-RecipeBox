//
//  Recipe.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//


import Foundation
import SwiftyJSON

struct Recipe {
    let id: Int
    let title: String
    let category: String
    let durationMinutes: Int
    let imageName: String
    let summary: String
    let ingredients: [String]
    let steps: [String]

    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.category = json["category"].stringValue
        self.durationMinutes = json["durationMinutes"].intValue
        self.imageName = json["imageName"].stringValue
        self.summary = json["summary"].stringValue
        self.ingredients = json["ingredients"].arrayValue.map { $0.stringValue }
        self.steps = json["steps"].arrayValue.map { $0.stringValue }
    }

    var mockRating: Double {
        let base = 45 + (id % 5) // 4.5 - 4.9
        return Double(base) / 10.0
    }
}
