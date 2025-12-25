//
//  HomeVC.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 23.12.2025.
//

import UIKit

final class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    private let service = RecipeService()
    private let dataSource = RecipesDataSource()
    private let favorites = FavoritesStore.shared

    private let recipesURL =
    "https://raw.githubusercontent.com/aserhatsahin/CTIS480-RecipeBox/refs/heads/develop/recipes.json"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        fetchAndReload()

        // Favorites değişince UI güncelle (FavoritesVC vs. ile senkron)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoritesChanged),
                                               name: .favoritesChanged,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func fetchAndReload() {
        service.fetchRecipes(from: recipesURL) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self.dataSource.setRecipes(recipes)
                    self.collectionView.reloadData()

                case .failure(let error):
                    print("fetch error:", error)
                }
            }
        }
    }

    @objc private func favoritesChanged() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.visibleRecipes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomRecipeCell",
                                                            for: indexPath) as? CustomRecipeCell
        else { return UICollectionViewCell() }

        let recipe = dataSource.visibleRecipes[indexPath.item]
        let isFav = favorites.isFavorite(id: recipe.id)

        cell.configure(with: recipe, isFavorite: isFav)

        cell.onFavoriteTapped = { [weak self, weak collectionView] in
            guard let self = self, let collectionView = collectionView else { return }

            self.favorites.toggleFavorite(id: recipe.id)

            // UI’ı sadece ilgili item için yenile
            collectionView.reloadItems(at: [indexPath])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}
