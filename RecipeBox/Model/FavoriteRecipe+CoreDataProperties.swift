//
//  FavoriteRecipe+CoreDataProperties.swift
//  
//
//  Created by goksu uzun on 26.12.2025.
//
//

public import Foundation
public import CoreData


public typealias FavoriteRecipeCoreDataPropertiesSet = NSSet

extension FavoriteRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        return NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
    }

    @NSManaged public var recipeId: Int64

}
