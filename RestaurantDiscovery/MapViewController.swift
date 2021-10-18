//
//  ViewController.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/13/21.
//

import Anchorage
import MapKit
import UIKit

class MapViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    let mapView = MKMapView()
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    var resultsVC = ResultsViewController()
    var toggleButton = UIButton(type: .custom)
    var showMap = true
    
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
        
        floatingButton()
        
        guard let newResultsVC = searchVC.searchResultsController as? ResultsViewController
        else { return }
        resultsVC = newResultsVC
        resultsVC.delegate = self
        resultsVC.hideTable(self.showMap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.userTrackingMode = MKUserTrackingMode.follow
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        mapView.edgeAnchors == view.edgeAnchors + insets
    }
    
    func floatingButton() {
        updateButtonTitle()
        toggleButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        toggleButton.tintColor = .white
        toggleButton.setTitleColor(.white, for: .normal)
        toggleButton.clipsToBounds = true
        toggleButton.layer.cornerRadius = 5
        toggleButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(toggleButton)
            toggleButton.widthAnchor == 85
            toggleButton.heightAnchor == 40
            toggleButton.centerXAnchor == window.centerXAnchor
            toggleButton.bottomAnchor == window.bottomAnchor - 50
        }
    }
    
    @objc func toggleTapped() {
        showMap = !showMap
        updateButtonTitle()
        resultsVC.hideTable(self.showMap)
    }
    
    func updateButtonTitle() {
        let imageAttachment = NSTextAttachment()
        
        if showMap {
            imageAttachment.image = UIImage(systemName: "list.bullet")?.withTintColor(.white)
            let fullString = NSMutableAttributedString(attachment: imageAttachment)
            fullString.append(NSAttributedString(string: " List"))
            toggleButton.setAttributedTitle(fullString, for: .normal)
        } else {
            imageAttachment.image = UIImage(systemName: "mappin.circle")?.withTintColor(.white)
            let fullString = NSMutableAttributedString(attachment: imageAttachment)
            fullString.append(NSAttributedString(string: " Map"))
            toggleButton.setAttributedTitle(fullString, for: .normal)
        }
        
    }
    
}

extension MapViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text
        else { return }
        
        GooglePlacesController.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                print(places)
                DispatchQueue.main.async {
                    self.resultsVC.hideTable(self.showMap)
                    if self.showMap {
                        self.addPlacesToMap(with: places)
                    } else {
                        self.resultsVC.update(with: places)
                    }
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension MapViewController: ResultsViewControllerDelegate {
    func toggleTableView(hide: Bool) {
        resultsVC.hideTable(!showMap)
    }
    
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
    
    func addPlacesToMap(with locations: [Place]) {
        // Remove all map pins
        mapView.removeAnnotations(mapView.annotations)
        
        // Add pins to the map
        for (place) in locations {
            GooglePlacesController.shared.allInfo(for: place.ID) { [weak self] result in
                switch result {
                case .success(let location):
                    DispatchQueue.main.async {
                        let pin = MKPointAnnotation()
                        pin.title = location.name
                        pin.coordinate = location.location
                        self?.mapView.addAnnotation(pin)
                        self?.mapView.showAnnotations(self?.mapView.annotations ?? [pin], animated: true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User gave app authorization")
        }
    }
    
}
