//
//  RecipeViewController.swift
//  AlbertsonsInterview
//
//  Created by Mark Anthony Corpuz on 1/31/21.
//

import UIKit

class RecipeViewContoller: UITableViewController {
    private enum Constants {
        static let dequeueCellIdentifier: String = "recipeTableViewCell"
    }
    var recipe: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Mushroom Recipes", comment: "title")
    }

    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.results.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = recipe.results[indexPath.row]
        guard let url = URL(string: result.href) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dequeueCellIdentifier, for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        cell.result = recipe.results[indexPath.row]
        return cell
    }
}
