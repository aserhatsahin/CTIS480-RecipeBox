//
//  CookingStepTableViewCell.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 26.12.2025.
//

import UIKit

class CookingStepTableViewCell: UITableViewCell {
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var stepTextLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stepNumberView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none

               // Card look
               cardView.layer.cornerRadius = 14
               cardView.layer.masksToBounds = true

               // Number bubble
               stepNumberView.layer.cornerRadius = 12
               stepNumberView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
            super.prepareForReuse()

            // Reset (default style)
            cardView.layer.borderWidth = 0
            cardView.layer.borderColor = UIColor.clear.cgColor
            cardView.backgroundColor = .systemGray6

            stepNumberView.backgroundColor = .systemGray4
            stepNumberLabel.textColor = .white

            stepTextLabel.textColor = .label
            stepTextLabel.font = .systemFont(ofSize: stepTextLabel.font.pointSize, weight: .regular)
        }

        /// VC bunu çağıracak.
        func configure(stepText: String, stepNumber: Int, isCurrent: Bool, isCompleted: Bool) {
            stepTextLabel.text = stepText
            stepNumberLabel.text = "\(stepNumber)"

            if isCurrent {
                cardView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
                cardView.layer.borderWidth = 2
                cardView.layer.borderColor = UIColor.systemBlue.cgColor

                stepNumberView.backgroundColor = .systemBlue
                stepNumberLabel.textColor = .white

                stepTextLabel.font = .systemFont(ofSize: stepTextLabel.font.pointSize, weight: .semibold)

            } else if isCompleted {
                cardView.backgroundColor = .systemGray6

                stepNumberView.backgroundColor = .systemGreen
                stepNumberLabel.textColor = .white

            } else {
                // upcoming
                cardView.backgroundColor = .systemGray6

                stepNumberView.backgroundColor = .systemGray4
                stepNumberLabel.textColor = .white
            }
        }
    }
