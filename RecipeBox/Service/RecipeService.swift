//
//  RecipeService.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 25.12.2025.
//

import Foundation
import SwiftyJSON

enum RecipeServiceError: Error {
    case invalidURL
    case invalidData
    case invalidJSON
}

final class RecipeService {

    func fetchRecipes(from urlString: String,
                      completion: @escaping (Result<[Recipe], Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(RecipeServiceError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(RecipeServiceError.invalidData))
                return
            }

            do {
                let json = try JSON(data: data)

                guard json["recipes"].exists() else {
                    completion(.failure(RecipeServiceError.invalidJSON))
                    return
                }

                let recipes = json["recipes"].arrayValue.map { Recipe(json: $0) }
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
