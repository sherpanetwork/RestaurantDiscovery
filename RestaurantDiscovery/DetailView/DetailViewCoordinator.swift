//
//  DetailViewCoordinator.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/17/21.
//

import SwiftUI

class DetailViewCoordinator {

    let viewModel: DetailViewModel

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
}

extension DetailViewCoordinator: ViewCoordinator {

    func start() -> AnyView {
        DetailView(viewModel: viewModel, coordinator: self).eraseToAnyView()
    }

}

extension DetailViewCoordinator: EventHandler {
    /// All possible events for this view.
    enum Event {

    }

    func send(_ event: Event) {

    }

}
