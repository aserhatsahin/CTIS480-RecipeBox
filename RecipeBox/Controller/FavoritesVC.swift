//
//  FavoritesVC.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 23.12.2025.
//

import UIKit

final class FavoritesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    let ds = RecipesDataSource()
    let favoritesStore = FavoritesStore()

    var favoriteRecipes: [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        ds.populateFromJSON()
        loadFavorites()
        collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        collectionView.reloadData()
    }

    private func loadFavorites() {
        let favIDs = favoritesStore.getFavoriteIDs()
        favoriteRecipes = ds.recipes.filter { favIDs.contains($0.id) }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteRecipes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomRecipeCell",
            for: indexPath
        ) as? CustomRecipeCell else {
            return UICollectionViewCell()
        }

        let recipe = favoriteRecipes[indexPath.item]

        cell.recipeNameLbl.text = recipe.title
        cell.recipeCookingTimeLbl.text = "⏱️ \(recipe.durationMinutes) min"
        cell.recipeRatingLbl.text = "★ \(String(format: "%.1f", recipe.mockRating))"
        cell.recipeImg.image = UIImage(named: recipe.imageName)

        cell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)

        cell.favoriteBtn.tag = indexPath.item
        cell.favoriteBtn.removeTarget(nil, action: nil, for: .allEvents)
        cell.favoriteBtn.addTarget(self, action: #selector(unfavoriteTapped(_:)), for: .touchUpInside)

        return cell
    }

    @objc private func unfavoriteTapped(_ sender: UIButton) {
        let recipe = favoriteRecipes[sender.tag]
        favoritesStore.toggleFavorite(id: recipe.id)

        loadFavorites()
        collectionView.reloadData()
    }
}
