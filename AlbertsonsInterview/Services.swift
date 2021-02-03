//
//  Services.swift
//  AlbertsonsInterview
//
//  Created by Mark Anthony Corpuz on 1/30/21.
//

import Foundation
import MapKit

struct Services {
    enum Constants {
        static let safeway = "Safeway"
    }

    //Obtains the url information and returns a closure of a Recipe object
    func getRecipeData(urlString: String, completion: @escaping (Recipe) -> Void) {
        NetworkingFunctions.getRequestData(urlString: urlString) { (data) in
            guard let data = data else { return }
            do {
                let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                completion(recipe)
            } catch {

            }
        }
    }

    //Finds the closest Safeway and returns a closure of the address
    func findClosestSafewayAddress(region: MKCoordinateRegion, completion: @escaping (String?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = Constants.safeway
        searchRequest.region = region
        searchRequest.resultTypes = .pointOfInterest

        let safewaySearch = MKLocalSearch(request: searchRequest)
        safewaySearch.start { (response, error) in
            guard error == nil else {
                return
            }
            if let safewayItem = response?.mapItems.first {
                completion(safewayItem.placemark.formattedAddress)
            }
        }
    }
}
