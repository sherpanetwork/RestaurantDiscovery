//
//  GooglePlacesController.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/13/21.
//

import Foundation
import GooglePlaces

class GooglePlacesController {
    static let shared = GooglePlacesController()
    private let client = GMSPlacesClient.shared()
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                print(error.debugDescription)
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            
            var restaurants: [GMSAutocompletePrediction] =  []
            for prediction in results {
                if prediction.types.contains("restaurant") {
                    restaurants.append(prediction)
                }
            }
            
            let places = restaurants.compactMap({
                Place(ID: $0.placeID, name: $0.attributedPrimaryText.string, address: $0.attributedFullText.string)
            })
            completion(.success(places))
            
        }
    }
    
    /// Get more info from GooglePlace API using a PlaceID.
    /// - Parameters:
    ///   - placeID: ID of the desired place.
    ///   - completion: The returned object from a fetchPlace using the given PlaceID.
    func allInfo(for placeID: String, completion: @escaping (Result<GooglePlace, Error>) -> Void) {
        client.fetchPlace(fromPlaceID: placeID, placeFields: .all, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            let place = GooglePlace(placeID: googlePlace.placeID ?? placeID, name: googlePlace.name, address: googlePlace.formattedAddress, phoneNumber: googlePlace.phoneNumber, location: googlePlace.coordinate, rating: googlePlace.rating, userRatingsTotal: googlePlace.userRatingsTotal)
            completion(.success(place))
            
        }
    }
    
}

enum PlacesError: Error {
    case failedToFind
    case failedToGetCoordinates
}
