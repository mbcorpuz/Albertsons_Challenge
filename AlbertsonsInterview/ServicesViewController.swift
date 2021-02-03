//
//  ServicesViewController.swift
//  AlbertsonsInterview
//
//  Created by Mark Anthony Corpuz on 1/30/21.
//

import UIKit
import MapKit

class ServicesViewController: UIViewController {
    private enum Constants {
        static let getAppURL: String  = "https://apps.apple.com/us/app/safeway-delivery-pick-up/id687460321"
        static let getRecipeURL: String = "http://www.recipepuppy.com/api/?q=mushroom"
        static let regionDistance: CLLocationDistance = 12_000
        static let cornerRadius: CGFloat = 5.0
        static let borderWidth: CGFloat = 2.0
    }

    private let locationManager = CLLocationManager()
    private let services = Services()

    @IBOutlet weak var getAppView: UIView!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var getAppButton: UIButton!
    @IBOutlet weak var getRecipeButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var getAppLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Services", comment: "VC Title")
        setupViews()
        requestLocation()
    }
    
    // setupViews adds layer properties to the main views of the view controller
    // also initializes text for the labels and buttons in the ViewController
    private func setupViews() {
        getAppView.layer.cornerRadius = Constants.cornerRadius
        getAppView.layer.borderWidth = Constants.borderWidth
        getAppView.layer.borderColor = UIColor.lightGray.cgColor

        recipeView.layer.cornerRadius = Constants.cornerRadius
        recipeView.layer.borderWidth = Constants.borderWidth
        recipeView.layer.borderColor = UIColor.lightGray.cgColor

        getAppButton.setTitle(NSLocalizedString("Get the App", comment: "Get App Button"), for: .normal)
        getRecipeButton.setTitle(NSLocalizedString("View Recipes", comment: "Get Recipe Button"), for: .normal)
        locationLabel.text = NSLocalizedString("Determining Closest Location", comment: "Location text")
        welcomeLabel.text = NSLocalizedString("Hello Guest! What would you like to do?", comment: "App Greeting Text")
        getAppLabel.text = NSLocalizedString("Get the delivery App", comment: "Get App Text")
        recipeLabel.text = NSLocalizedString("Recipes with the Ingredient of the day - Mushrooms", comment: "Search Recipe Text")
    }

    // Displays a UIAlertController asking user to go to settings to enable location services
    func goToLocationSettings() {
        let title = NSLocalizedString("Location Services not enabled for App", comment: "")
        let message = NSLocalizedString("Please turn on the location based settings. Continue to settings?", comment: "")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { (selected) in
            if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        present(alertController, animated: true, completion: nil)
    }

    // requests location from the locationManager
    private func requestLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            goToLocationSettings()
            return
        }
        locationManager.delegate = self

        guard locationManager.authorizationStatus != .denied else {
            goToLocationSettings()
            return
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    // displays error from location manager delegate
    private func displayError(error: Error) {
        let title = NSLocalizedString("Location Services Error", comment: "")
        let message = error.localizedDescription
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
            goToLocationSettings()
        }
    }

    @IBAction func getAppPressed(_ sender: UIButton) {
        guard let url = URL(string: Constants.getAppURL) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func getRecipePressed(_ sender: UIButton) {
        services.getRecipeData(urlString: Constants.getRecipeURL) { [weak self] (recipe) in
            DispatchQueue.main.async {
                guard let vc = self?.storyboard?.instantiateViewController(identifier: "RecipeViewContoller") as? RecipeViewContoller else { return }
                vc.recipe = recipe
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ServicesViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .denied, .restricted:
                goToLocationSettings()
                break
            default:
                requestLocation()
                break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: Constants.regionDistance, longitudinalMeters: Constants.regionDistance)
        services.findClosestSafewayAddress(region: region) { [unowned self] (address) in
            guard let address = address else { return }
            self.locationLabel.text = address
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        displayError(error: error)
    }
}
