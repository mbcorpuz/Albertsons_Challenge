//
//  RecipeTableViewCell.swift
//  AlbertsonsInterview
//
//  Created by Mark Anthony Corpuz on 1/31/21.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var imageViewView: UIView!

    var result: Result? {
        didSet {
            guard let result = result else { return }
            title.text = result.title
            ingredients.text = "Ingredients: \(result.ingredients)"
            if result.thumbnail != "" {
                guard let url = URL(string: result.thumbnail) else { return }
                imageViewView.isHidden = false
                resultImageView?.kf.setImage(with: url)
            } else {
                imageViewView.isHidden = true
                resultImageView.image = nil
            }
        }
    }
}
