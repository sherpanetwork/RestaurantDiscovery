//
//  DetailViewModel.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/17/21.
//

import SwiftUI

class DetailViewModel: ObservableObject {

    @Published var place: GooglePlace

    init(place: GooglePlace) {
        self.place = place
    }
}
