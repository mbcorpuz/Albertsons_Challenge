//
//  MKPlacemark+Extension.swift
//  AlbertsonsInterview
//
//  Created by Mark Anthony Corpuz on 2/1/21.
//

import Foundation
import MapKit
import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return "\(postalAddress.street), \(postalAddress.city), \(postalAddress.state) \(postalAddress.postalCode)"
    }
}
