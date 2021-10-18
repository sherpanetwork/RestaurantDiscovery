//
//  DetailView.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/17/21.
//

import SwiftUI
import CoreLocation

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    let coordinator: DetailViewCoordinator
    
    var body: some View {
        VStack {
            
            Text(viewModel.place.name ?? "MISSING")
            Text(viewModel.place.address ?? "MISSING")
            Text(viewModel.place.phoneNumber ?? "MISSING")
            HStack {
                Text("Rating: \(viewModel.place.rating)")
                Text("Reviews: \(viewModel.place.userRatingsTotal)")
            }
            
        }
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        let view = DetailViewCoordinator(viewModel: DetailViewModel(place: GooglePlace(placeID: "ChIJp_-LF-p9VIcRLZCkt0y4oxY", name: "Chick-fil-A", address: "1323 N Main St, Logan, UT 84341, USA", phoneNumber: "+1 435-755-8300", location: CLLocationCoordinate2D(latitude: 41.7563104, longitude: -111.8348072), rating: 4.6, userRatingsTotal: 2085))).start()
        
        Group {
            view
        }
    }
}
