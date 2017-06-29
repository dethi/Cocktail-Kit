//
//  RandomViewController.swift
//  Cocktail Kit
//
//  Copyright © 2017 ATKF. All rights reserved.
//

import UIKit

class RandomViewController: UIViewController {

    var cocktail: CocktailRecord?

    @IBOutlet weak var cocktailImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cocktailImage.layer.masksToBounds = true
        self.cocktailImage.layer.cornerRadius = 20

        getRandomCocktail()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let cocktail = cocktail {
            self.navigationItem.title = cocktail.name
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = nil
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getRandomCocktail() {
        SearchService.shared.pickRandom { (cocktail) in
            self.cocktail = cocktail

            self.navigationItem.title = cocktail.name
            if let url = cocktail.getImageURL() {
                self.cocktailImage.af_setImage(withURL: url)
            } else {
                self.cocktailImage.image = #imageLiteral(resourceName: "Question Mark")
            }
        }
    }

    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier == "RandomCocktailDetail" && cocktail != nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CocktailDetailTableViewController, let cocktail = cocktail {
            destination.cocktail = cocktail
        }
    }
}
