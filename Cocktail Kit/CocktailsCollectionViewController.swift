//
//  CocktailsCollectionViewController.swift
//  Cocktail Kit
//
//  Copyright © 2017 ATKF. All rights reserved.
//

import UIKit
import AlgoliaSearch
import AlamofireImage

private let reuseIdentifier = "CocktailCell"

private let itemsPerRow: CGFloat = 2
private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

class CocktailsCollectionViewController: UICollectionViewController {

    var cocktails = [CocktailRecord]()
    var searchId = 0
    var displayedSearchId = 0
    var isLoadingMore = false
    var loadedPage = 0
    var nbPages = 0

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()

        searchController.searchBar.text = ""
        updateSearchResults(for: searchController)

        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func favoriteDoubleTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }

        let point = sender.location(in: collectionView)
        if let indexPath = collectionView?.indexPathForItem(at: point) {
            SearchService.shared.write {
                cocktails[indexPath.row].toggleFavorite()
            }
            collectionView?.reloadItems(at: [indexPath])
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CocktailDetailTableViewController, let indexPath = collectionView?.indexPathsForSelectedItems?.first {
            destination.cocktail = cocktails[indexPath.row]
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cocktails.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CocktailViewCell

        let cocktail = cocktails[indexPath.row]
        cell.setCocktail(cocktail)

        if (indexPath.row + 4) >= cocktails.count {
            loadMore()
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)

            return headerView
        }

        return UICollectionReusableView()
    }
}

extension CocktailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth /  itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension CocktailsCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let curSearchId = searchId
            searchId += 1

            SearchService.shared.search(searchText) { (cocktails, nbPages) in
                guard curSearchId > self.displayedSearchId else { return }

                self.displayedSearchId = curSearchId
                self.loadedPage = 1
                self.nbPages = nbPages
                self.isLoadingMore = false

                self.cocktails = cocktails
                self.collectionView?.reloadData()
            }
        }
    }

    func loadMore() {
        guard !isLoadingMore else { return }
        guard loadedPage < nbPages else { return }
        guard let curQuery = searchController.searchBar.text else { return }

        isLoadingMore = true

        let curPage = loadedPage + 1
        SearchService.shared.search(curQuery, page: curPage) { (cocktails, nbPages) in
            guard curQuery == self.searchController.searchBar.text else { return }

            self.loadedPage = curPage
            self.isLoadingMore = false

            self.cocktails.append(contentsOf: cocktails)
            self.collectionView?.reloadData()
        }
    }
}
