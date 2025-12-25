//
//  CustomRecipeCell.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 24.12.2025.
//

import UIKit

final class CustomRecipeCell: UICollectionViewCell {

    @IBOutlet weak var recipeRatingLbl: UILabel!
    @IBOutlet weak var recipeCookingTimeLbl: UILabel!
    @IBOutlet weak var recipeNameLbl: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

    }
}

