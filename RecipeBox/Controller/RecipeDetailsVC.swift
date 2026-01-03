//
//  RecipeDetailsVC.swift
//  RecipeBox
//
//  Created by Ahmet Serhat Sahin on 23.12.2025.
//

import UIKit

protocol RecipeDelegate: AnyObject {
    func recipeDetailsDidToggleFavorite(recipeId: Int)
}

final class RecipeDetailsVC: UIViewController {
    @IBOutlet weak var recipeDetailsTableView: UITableView!
    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var recipeIMG: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mFavoriteBtn: UIButton!
    
    var selectedRecipe: Recipe?
    weak var delegate: RecipeDelegate?
    private enum Mode { case ingredients, steps }
    private var mode: Mode = .ingredients
    private let favoritesStore = FavoritesStore()
    private var originalImageTransform: CGAffineTransform = .identity
    private let pinchHintLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPinchHintLabel()
        
        guard let recipe = selectedRecipe else {
            print("selectedRecipe is nil")
            return
        }
        
        recipeIMG.image = UIImage(named: recipe.imageName)
        titleLabel.text = recipe.title
        
        recipeDetailsTableView.dataSource = self
        recipeDetailsTableView.delegate = self
        recipeDetailsTableView.rowHeight = UITableView.automaticDimension
        recipeDetailsTableView.estimatedRowHeight = 80
        
        configureSegmented()
        updateFavoriteIcon()
    }
    
    private func updateFavoriteIcon() {
        guard let recipe = selectedRecipe else { return }
        let isFav = favoritesStore.isFavorite(id: recipe.id)
        let heartName = isFav ? "heart.fill" : "heart"
        mFavoriteBtn.setImage(UIImage(systemName: heartName), for: .normal)
        mFavoriteBtn.tintColor = isFav ? .systemRed : .systemGray
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        guard let recipe = selectedRecipe else { return }
        
        favoritesStore.toggleFavorite(id: recipe.id)
        updateFavoriteIcon()
        
        delegate?.recipeDetailsDidToggleFavorite(recipeId: recipe.id)
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        mode = (sender.selectedSegmentIndex == 0) ? .ingredients : .steps
        recipeDetailsTableView.reloadData()
    }
    @IBAction func onGestureTriggered(_ sender: UIPinchGestureRecognizer) {
        guard let targetView = sender.view else { return }
        
        switch sender.state {
        case .began:
            originalImageTransform = targetView.transform
            self.view.bringSubviewToFront(targetView)
            
            UIView.animate(withDuration: 0.2) {
                self.pinchHintLabel.alpha = 0.0
            }
            
        case .changed:
            targetView.transform = targetView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1.0
            
        case .ended, .cancelled, .failed:
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                targetView.transform = self.originalImageTransform // veya .identity
            }
            
            UIView.animate(withDuration: 0.25, delay: 0.05) {
                self.pinchHintLabel.alpha = 1.0
            }
            
        default:
            break
        }
    }
    
    private func addPinchHintLabel() {
        pinchHintLabel.text = "Pinch to zoom"
        pinchHintLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        pinchHintLabel.textColor = .white
        pinchHintLabel.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        pinchHintLabel.textAlignment = .center
        pinchHintLabel.layer.cornerRadius = 10
        pinchHintLabel.clipsToBounds = true
        
        pinchHintLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeIMG.addSubview(pinchHintLabel)
        
        NSLayoutConstraint.activate([
            pinchHintLabel.centerXAnchor.constraint(equalTo: recipeIMG.centerXAnchor),
            pinchHintLabel.bottomAnchor.constraint(equalTo: recipeIMG.bottomAnchor, constant: -12),
            pinchHintLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            pinchHintLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        pinchHintLabel.alpha = 1.0
    }
}

private extension RecipeDetailsVC {
    func configureSegmented() {
        segmentedView.selectedSegmentIndex = 0
        mode = .ingredients
    }
}

extension RecipeDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = selectedRecipe else { return 0 }
        return (mode == .ingredients) ? recipe.ingredients.count : recipe.steps.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let recipe = selectedRecipe else { return UITableViewCell() }
        
        switch mode {
        case .ingredients:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ingredientsCell",
                for: indexPath
            ) as! CustomIngredientsCell
            
            let ing = recipe.ingredients[indexPath.row]
            cell.amountLbl.text = ing.amount
            cell.ingredientLbl.text = ing.name
            
            return cell
            
        case .steps:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "stepsCell",
                for: indexPath
            ) as! CustomStepsCell
            
            cell.stepNoBtn.setTitle("\(indexPath.row + 1)", for: .normal)
            cell.stepNoBtn.isUserInteractionEnabled = false
            cell.textView.text = recipe.steps[indexPath.row]
            cell.textView.isScrollEnabled = false
            
            return cell
        }
    }
}
