//
//  ViewController.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/13/21.
//

import Anchorage
import MapKit
import UIKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    let mapView = MKMapView()
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "AllTrails at Lunch"
        view.addSubview(mapView)
        
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.userTrackingMode = MKUserTrackingMode.follow
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        mapView.edgeAnchors == view.edgeAnchors + insets
    }
    
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultsViewController
        else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesController.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                print(places)
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension ViewController: ResultsViewControllerDelegate {
    func didTapPlace(with location: CLLocation) {
        searchVC.dismiss(animated: true, completion: nil)
        
        // Remove all map pins
        mapView.removeAnnotations(mapView.annotations)
        
        // Add a pin to the map
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User gave app authorization")
        }
    }
    
}
