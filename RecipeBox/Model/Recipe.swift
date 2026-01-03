import Foundation
import SwiftyJSON

// ✅ Yeni model: ingredient artık obje
struct Ingredient {
    let amount: String
    let name: String

    init(json: JSON) {
        self.amount = json["amount"].stringValue
        self.name = json["name"].stringValue
    }
}

struct Recipe {
    let id: Int
    let title: String
    let category: String
    let durationMinutes: Int
    let imageName: String
    let summary: String
    let ingredients: [Ingredient]   // ✅ [String] yerine
    let steps: [String]

    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.category = json["category"].stringValue
        self.durationMinutes = json["durationMinutes"].intValue
        self.imageName = json["imageName"].stringValue
        self.summary = json["summary"].stringValue

        // ✅ ingredients artık object array
        self.ingredients = json["ingredients"].arrayValue.map { Ingredient(json: $0) }

        self.steps = json["steps"].arrayValue.map { $0.stringValue }
    }

    var mockRating: Double {
        let base = 45 + (id % 5) // 4.5 - 4.9
        return Double(base) / 10.0
    }
}
