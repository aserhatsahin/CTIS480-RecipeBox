//
//  CustomRecipeCell.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 24.12.2025.
//

import UIKit

class CustomRecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeRatingLbl: UILabel!
    @IBOutlet weak var recipeCookingTimeLbl: UILabel!
    @IBOutlet weak var recipeNameLbl: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    var onFavoriteTapped: (() -> Void)?

        /// Commit msg: "Wire favorite button action via closure callback"
        @IBAction func favoriteTapped(_ sender: UIButton) {
            onFavoriteTapped?()
        }

        /// Cell UI’ını basar.
        /// Commit msg: "Add configure(...) to CustomRecipeCell"
        func configure(with recipe: Recipe, isFavorite: Bool) {
            recipeNameLbl.text = recipe.title
            recipeCookingTimeLbl.text = recipe.durationText
            recipeRatingLbl.text = String(format: "%.1f", recipe.mockRating)

            recipeImg.image = UIImage(named: recipe.imageName)

            // Kalp iconu (SF Symbols kullanıyorsan)
            let symbolName = isFavorite ? "heart.fill" : "heart"
            favoriteBtn.setImage(UIImage(systemName: symbolName), for: .normal)
            
            recipeCookingTimeLbl.text = "⏱️ \(recipe.durationText)"
            recipeRatingLbl.text = "★ \(String(format: "%.1f", recipe.mockRating))"
        }
    
        override func awakeFromNib() {
            super.awakeFromNib()


            
            // Border
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.systemGray4.cgColor
            contentView.layer.cornerRadius = 14
            contentView.layer.masksToBounds = true

            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.08
            layer.shadowRadius = 8
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.masksToBounds = false
        }
        
    }


