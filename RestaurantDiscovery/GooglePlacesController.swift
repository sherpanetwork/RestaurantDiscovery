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
    
    init() {
        
    }
    
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
                Place(name: $0.attributedFullText.string, ID: $0.placeID)
            })
            completion(.success(places))
            
        }
    }
    
    func resolveLocation(for place: Place, completion: @escaping (Result<CLLocation, Error>) -> Void){
        client.fetchPlace(fromPlaceID: place.ID, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            let location = CLLocation(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(location))
            
        }
    }
    
}

struct Place {
    let name: String
    let ID: String
}

enum PlacesError: Error {
    case failedToFind
    case failedToGetCoordinates
}
