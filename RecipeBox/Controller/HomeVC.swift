//
//  HomeVC.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 23.12.2025.
//

import UIKit




final class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RecipeDelegate {
    func recipeDetailsDidToggleFavorite(recipeId: Int) {
        if let index = ds.recipes.firstIndex(where: { $0.id == recipeId }) {
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            collectionView.reloadData()
        }
    }
    
    var selectedRecipe: Recipe?
    @IBOutlet weak var collectionView: UICollectionView!

    let ds = RecipesDataSource()
    let favoritesStore = FavoritesStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        ds.populateFromJSON()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func unwindToMain(_ sender:UIStoryboardSegue) {
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ds.recipes.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomRecipeCell",
            for: indexPath
        ) as? CustomRecipeCell else {
            return UICollectionViewCell()
        }

        let recipe = ds.recipes[indexPath.item]

        cell.recipeNameLbl.text = recipe.title
        cell.recipeCookingTimeLbl.text = "⏱️ \(recipe.durationMinutes) min"
        cell.recipeRatingLbl.text = "★ \(String(format: "%.1f", recipe.mockRating))"

        if let img = UIImage(named: recipe.imageName) {
            cell.recipeImg.image = img
        } else {
            cell.recipeImg.image = UIImage(named: "placeholder") // varsa
            print("Missing asset:", recipe.imageName)
        }

        let isFav = favoritesStore.isFavorite(id: recipe.id)
        let heartName = isFav ? "heart.fill" : "heart"
        let color: UIColor = isFav ? .systemRed : .systemGray
        cell.favoriteBtn.setImage(UIImage(systemName: heartName), for: .normal)
        cell.favoriteBtn.tintColor = color

        cell.favoriteBtn.tag = indexPath.item

        cell.favoriteBtn.removeTarget(nil, action: nil, for: .allEvents)
        cell.favoriteBtn.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)

        return cell
    }
 
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRecipe = ds.recipes[indexPath.item]
        performSegue(withIdentifier: "toRecipeDetailsSegue", sender: self)
    }
    
    
    @objc private func favoriteTapped(_ sender: UIButton) {
        let index = sender.tag
        let recipe = ds.recipes[index]

        favoritesStore.toggleFavorite(id: recipe.id)

        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

}
extension HomeVC  {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailsSegue" {
            if let RPVC = segue.destination as? RecipeDetailsVC {
                RPVC.delegate = self
                RPVC.selectedRecipe=selectedRecipe
            }
        }

     
    }
    
    
}
