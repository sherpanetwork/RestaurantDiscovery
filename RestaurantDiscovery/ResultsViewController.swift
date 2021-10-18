//
//  ResultsViewController.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/13/21.
//

import CoreLocation
import SwiftUI
import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with location: CLLocation)
    func addPlacesToMap(with locations: [Place])
    func toggleTableView(hide: Bool)
}

class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsViewControllerDelegate?
    var places = [Place]()
    var shouldHideTable = true
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func update(with places: [Place]) {
        self.tableView.isHidden = shouldHideTable
        self.places = places
        tableView.reloadData()
    }
    
    func hideTable(_ hide: Bool) {
        shouldHideTable = hide
        self.tableView.isHidden = hide
        tableView.reloadData()
    }
    
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let place = places[indexPath.row]
        
        GooglePlacesController.shared.allInfo(for: place.ID) { [weak self] result in
            switch result {
            case .success(let googlePlace):
                print(googlePlace)
                DispatchQueue.main.async {
                    // Create swiftUI coordinator with it's viewModel.
                    let coordinator = DetailViewCoordinator(viewModel: DetailViewModel(place: googlePlace))
                    // Create a UIHostingController in order to insert the SwiftUI view into UIKit.
                    let swiftUIDetailView = UIHostingController(rootView: coordinator.start())
                    self?.present(swiftUIDetailView, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
