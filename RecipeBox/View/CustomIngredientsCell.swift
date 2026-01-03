//
//  CustomIngredientsCell.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 3.01.2026.
//

import UIKit

class CustomIngredientsCell: UITableViewCell {

    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var ingredientLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
