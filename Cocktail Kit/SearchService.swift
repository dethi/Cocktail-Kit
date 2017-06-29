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

    private var nbOfRecords = 0

    private init() {
        index = client.index(withName: "Cocktail-Kit")
        index.searchCacheEnabled = true
    }

    func search(query: String, completion: @escaping (_ cocktails: [CocktailRecord]) -> Void) {
        index.search(Query(query: query)) { (res, err) in
            guard err == nil else { return }
            guard let res = res else { return }
            guard let nbHits = res["nbHits"] as? Int else { return }
            guard let hits = res["hits"] as? [[String: AnyObject]] else { return }

            if query.isEmpty {
                self.nbOfRecords = nbHits
            }

            var cocktails = [CocktailRecord]()
            for hit in hits {
                cocktails.append(CocktailRecord(json: hit))
            }
            completion(cocktails)
        }
    }

    func pickRandom(completion: @escaping (_ cocktail: CocktailRecord) -> Void) {
        let id = Int(arc4random_uniform(UInt32(nbOfRecords)))
        index.getObject(withID: "\(id)") { (res, err) in
            guard err == nil else { return }
            guard let res = res else { return }

            let cocktail = CocktailRecord(json: res as [String : AnyObject])
            completion(cocktail)
        }
    }
}
