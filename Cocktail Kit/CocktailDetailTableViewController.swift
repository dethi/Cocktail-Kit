//
//  CocktailDetailTableViewController.swift
//  Cocktail Kit
//
//  Created by Thibault Deutsch on 28/06/2017.
//  Copyright © 2017 ATKF. All rights reserved.
//

import UIKit

class CocktailDetailTableViewController: UITableViewController {

    var cocktail: CocktailRecord?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44

        if let cocktail = cocktail {
            self.title = cocktail.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Detail"
        case 1:
            return "Ingredients"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return cocktail?.ingredients.count ?? 0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath)
            cell.textLabel?.text = cocktail?.instructions
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)

        if let ingredient = cocktail?.ingredients[indexPath.row] {
            cell.textLabel?.text = ingredient.name
            cell.detailTextLabel?.text = ingredient.measure
            if let url = ingredient.image {
                cell.imageView?.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Question Mark"))
            }
        }

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
