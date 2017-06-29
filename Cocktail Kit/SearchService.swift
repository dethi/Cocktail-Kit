//
//  SearchService.swift
//  Cocktail Kit
//
//  Copyright © 2017 ATKF. All rights reserved.
//

import Foundation
import AlgoliaSearch
import RealmSwift

class SearchService {
    static let shared = SearchService()

    private let client = Client(appID: "QJD6ORETUC", apiKey: "b4815357a61bd83281803add2cd9f51b")
    private let index: Index

    private let realm = try! Realm()

    private var nbOfRecords = 0

    let favorites: Results<CocktailRecord>

    private init() {
        index = client.index(withName: "Cocktail-Kit")
        index.searchCacheEnabled = true

        favorites = realm.objects(CocktailRecord.self).filter("favorite == true")
    }

    func search(_ query: String, completion: @escaping (_ cocktails: [CocktailRecord], _ nbPages: Int) -> Void) {
        search(query, page: 0, completion: completion)
    }

    func search(_ query: String, page: Int, completion: @escaping (_ cocktails: [CocktailRecord], _ nbPages: Int) -> Void) {
        let q = Query(query: query)
        q.page = UInt(page)

        index.search(q) { (res, err) in
            guard let res = res else { return }
            guard let nbHits = res["nbHits"] as? Int else { return }
            guard let nbPages = res["nbPages"] as? Int else { return }
            guard let hits = res["hits"] as? [[String: AnyObject]] else { return }

            if query.isEmpty {
                self.nbOfRecords = nbHits
            }

            var cocktails = [CocktailRecord]()
            try! self.realm.write {
                for hit in hits {
                    let cocktail = self.realm.create(CocktailRecord.self, value: hit, update: true)
                    cocktails.append(cocktail)
                }
            }

            completion(cocktails, nbPages)
        }
    }

    func pickRandom(_ completion: @escaping (_ cocktail: CocktailRecord) -> Void) {
        let id = Int(arc4random_uniform(UInt32(nbOfRecords)))
        index.getObject(withID: "\(id)") { (res, err) in
            guard let res = res else { return }

            let cocktail = CocktailRecord(value: res)
            try! self.realm.write {
                self.realm.add(cocktail, update: true)
            }
            completion(cocktail)
        }
    }

    func write(_ block: (() -> Void)) {
        try! realm.write {
            block()
        }
    }
}
