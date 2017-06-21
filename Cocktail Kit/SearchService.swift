//
//  SearchService.swift
//  Cocktail Kit
//
//  Created by Thibault Deutsch on 16/06/2017.
//  Copyright © 2017 ATKF. All rights reserved.
//

import Foundation
import AlgoliaSearch

class SearchService {
    static let shared = SearchService()

    private let client = Client(appID: "QJD6ORETUC", apiKey: "b4815357a61bd83281803add2cd9f51b")
    private let index: Index

    private init() {
        index = client.index(withName: "Cocktail-Kit")
        index.searchCacheEnabled = true
    }

    func search(query: String, completion: @escaping (_ cocktails: [CocktailRecord]) -> Void) {
        index.search(Query(query: query)) { (res, err) in
            if err != nil { return }
            guard let hits = res!["hits"] as? [[String: AnyObject]] else { return }

            var cocktails = [CocktailRecord]()
            for hit in hits {
                cocktails.append(CocktailRecord(json: hit))
            }
            completion(cocktails)
        }
    }
}
