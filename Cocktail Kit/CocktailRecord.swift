//
//  CocktailRecord.swift
//  Cocktail Kit
//
//  Created by Thibault Deutsch on 16/06/2017.
//  Copyright © 2017 ATKF. All rights reserved.
//

import Foundation

struct CocktailRecord {
    let objectID: String
    let name: String
    let isAlcoholic: Bool
    let instructions: String?
    let image: URL?
    let category: String?
    let glass: String?
    let dateModified: String?
    let ingredients: [IngredientRecord]

    init(json: [String: AnyObject]) {
        self.objectID = json["objectID"] as! String
        self.name = json["name"] as! String
        self.isAlcoholic = (json["isAlcoholic"] as? Bool) ?? false
        self.instructions = json["instructions"] as? String

        if let img = json["image"] as? String {
            self.image = URL(string: img)
        } else {
            self.image = nil
        }

        self.category = json["category"] as? String
        self.glass = json["glass"] as? String
        self.dateModified = json["dateModified"] as? String

        var ingredients = [IngredientRecord]()
        if let jsonIngredients = json["ingredients"] as? [[String: AnyObject]] {
            for jsonIngredient in jsonIngredients {
                ingredients.append(IngredientRecord(json: jsonIngredient))
            }
        }
        self.ingredients = ingredients
    }
}

struct IngredientRecord {
    let name: String
    let measure: String?
    let image: URL?

    init(json: [String: AnyObject]) {
        name = json["name"] as! String
        measure = json["measure"] as? String

        if let img = json["image"] as? String {
            image = URL(string: img)
        } else {
            image = nil
        }
    }
}
