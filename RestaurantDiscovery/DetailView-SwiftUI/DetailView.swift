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
        HStack {
            Image("detailsPlaceholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120, alignment: .center)
                
            VStack(alignment: .leading, spacing: 4) {
                
                Text(viewModel.place.name ?? "MISSING")
                    .font(.title)
                HStack {
                    RatingView(rating: Int(viewModel.place.rating))
                    Text("(\(viewModel.place.userRatingsTotal))")
                        .font(.footnote)
                }
                Text(viewModel.place.phoneNumber ?? "MISSING")
                Text(viewModel.place.address ?? "MISSING")
                
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
