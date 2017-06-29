//
//  FavoritesTableViewController.swift
//  Cocktail Kit
//
//  Created by Thibault Deutsch on 15/06/2017.
//  Copyright © 2017 ATKF. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchService.shared.favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let cocktail = SearchService.shared.favorites[indexPath.row]

        cell.textLabel?.text = cocktail.name
        if let url = cocktail.getImageURL() {
            cell.imageView?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Question Mark"))
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cocktail = SearchService.shared.favorites[indexPath.row]
            SearchService.shared.write {
                cocktail.toggleFavorite()
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CocktailDetailTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            destination.cocktail = SearchService.shared.favorites[indexPath.row]
        }
    }
}
