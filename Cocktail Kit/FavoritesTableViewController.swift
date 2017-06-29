//
//  FavoritesTableViewController.swift
//  Cocktail Kit
//
//  Copyright © 2017 ATKF. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        cancelAction(cancelButton)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func editAction(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        updateButtonsToMatchTableState()
    }

    @IBAction func cancelAction(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }

    @IBAction func deleteAction(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var favoritesToRemove = [CocktailRecord]()
            for indexPath in selectedRows {
                favoritesToRemove.append(SearchService.shared.favorites[indexPath.row])
            }

            SearchService.shared.write {
                for favorite in favoritesToRemove {
                    favorite.toggleFavorite()
                }
            }
            tableView.deleteRows(at: selectedRows, with: .fade)
        }

        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }

    func updateButtonsToMatchTableState() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = cancelButton
            navigationItem.leftBarButtonItem = deleteButton
        } else {
            navigationItem.rightBarButtonItem = editButton
            navigationItem.leftBarButtonItem = nil
        }
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

        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cocktail.name
        if let url = cocktail.getImageURL() {
            cell.imageView?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Question Mark"))
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier == "FavoriteCocktailDetail" && !tableView.isEditing
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CocktailDetailTableViewController, let indexPath = tableView.indexPathForSelectedRow {
            destination.cocktail = SearchService.shared.favorites[indexPath.row]
        }
    }
}
