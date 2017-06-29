//
//  CocktailViewCell.swift
//  Cocktail Kit
//
//  Created by Thibault Deutsch on 15/06/2017.
//  Copyright © 2017 ATKF. All rights reserved.
//

import UIKit

class CocktailViewCell: UICollectionViewCell {

    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var categoryTextField: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteIconView: UIImageView!

    func setCocktail(_ cocktail: CocktailRecord) {
        layer.masksToBounds = true
        layer.cornerRadius = 10

        nameTextField.text = cocktail.name
        categoryTextField.text = cocktail.category
        if let url = cocktail.getImageURL() {
            imageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "Cell Placeholder"))
        } else {
            imageView.image = #imageLiteral(resourceName: "Cell Placeholder")
        }
        favoriteIconView.image = favoriteIconView.image?.withRenderingMode(.alwaysTemplate)
        favoriteIconView.isHidden = !cocktail.isFavorite()
    }
}
