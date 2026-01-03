//
//  CustomStepsCell.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 3.01.2026.
//

import UIKit

class CustomStepsCell: UITableViewCell {

    @IBOutlet weak var stepNoBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
