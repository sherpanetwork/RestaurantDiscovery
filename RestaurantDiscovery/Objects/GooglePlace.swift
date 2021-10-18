//
//  GooglePlace.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/17/21.
//

import CoreLocation
import Foundation

public struct GooglePlace {
    let placeID: String
    let name: String?
    let address: String?
    let phoneNumber: String?
    let location: CLLocationCoordinate2D
    let rating: Float
    let userRatingsTotal: UInt
}
