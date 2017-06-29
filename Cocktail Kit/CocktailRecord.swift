//
//  CocktailRecord.swift
//  Cocktail Kit
//
//  Copyright © 2017 ATKF. All rights reserved.
//

import Foundation
import RealmSwift

class CocktailRecord : Object {
    dynamic var objectID = ""
    dynamic var name = ""
    dynamic var isAlcoholic = false
    dynamic var instructions: String?
    dynamic var image: String?
    dynamic var category: String?
    dynamic var glass: String?
    dynamic var dateModified: String?
    let favorite = RealmOptional<Bool>()

    let ingredients = List<IngredientRecord>()

    override static func primaryKey() -> String? {
        return "objectID"
    }

    override static func indexedProperties() -> [String] {
        return ["favorite"]
    }

    func getImageURL() -> URL? {
        guard let img = image else { return nil }
        return URL(string: img)
    }

    func isFavorite() -> Bool {
        return favorite.value ?? false
    }

    func toggleFavorite() {
        favorite.value = !(favorite.value ?? false)
    }
}

class IngredientRecord : Object {
    dynamic var name: String = ""
    dynamic var measure: String?
    dynamic var image: String?

    func getImageURL() -> URL? {
        guard let img = image else { return nil }
        return URL(string: img)
    }
}
