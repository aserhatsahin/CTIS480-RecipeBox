import UIKit

protocol RecipeDelegate: AnyObject {
    func recipeDetails(recipe: Recipe)
}

final class RecipeDetailsVC: UIViewController {

    @IBOutlet weak var recipeDetailsTableView: UITableView!
    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var recipeIMG: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var selectedRecipe: Recipe?
    weak var delegate: RecipeDelegate?

    private enum Mode { case ingredients, steps }
    private var mode: Mode = .ingredients

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let recipe = selectedRecipe else {
            print("selectedRecipe is nil")
            return
        }

        recipeIMG.image = UIImage(named: recipe.imageName)
        titleLabel.text = recipe.title

        // ✅ storyboarddan bağladıysan bile güvenli olsun:
        recipeDetailsTableView.dataSource = self
        recipeDetailsTableView.delegate = self

        // steps cell textView uzuyorsa lazım:
        recipeDetailsTableView.rowHeight = UITableView.automaticDimension
        recipeDetailsTableView.estimatedRowHeight = 80

        configureSegmented()
    }

    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        mode = (sender.selectedSegmentIndex == 0) ? .ingredients : .steps
        recipeDetailsTableView.reloadData()
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

            // ✅ artık split yok: direkt amount + name
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
