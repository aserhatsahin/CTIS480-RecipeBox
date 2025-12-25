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
    let summary: String
    let durationMinutes: Int
    let servings: Int
    let ingredients: [String]
    let steps: [String]
    let imageName: String

    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.category = json["category"].stringValue
        self.summary = json["summary"].stringValue
        self.durationMinutes = json["durationMinutes"].intValue
        self.servings = json["servings"].intValue
        self.ingredients = json["ingredients"].arrayValue.map { $0.stringValue }
        self.steps = json["steps"].arrayValue.map { $0.stringValue }
        self.imageName = json["imageName"].stringValue
    }

    /// JSON’da rating yok → deterministik mock.
    var mockRating: Double {
        // 4.5 - 4.9
        let base = 45 + (id % 5) // 45..49
        return Double(base) / 10.0
    }

    /// UI’da göstermek için "X min" stringi.
    var durationText: String {
        "\(durationMinutes) min"
    }
}
