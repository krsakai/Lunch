//
//  MapViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/27.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import MapKit

internal final class MapViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Property
    fileprivate var store: Store!
    
    // MARK: - Initializer
    
    static func instantiate(store: Store) -> MapViewController {
        let viewController = R.storyboard.mapViewController.mapViewController()!
        viewController.store = store
        return viewController
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView(store.name, headerItems: HeaderItems(leftItems: [.back], rightItems: nil))
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(store.latitude.degree, store.longitude.degree)
        mapView.addAnnotation(annotation)
        
        let targetLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        if let curerntLocation = DeviceModel.currentLocation {
            let degree = curerntLocation.distance(from: targetLocation)
            let region = MKCoordinateRegionMakeWithDistance(curerntLocation.coordinate, degree * 2.25, degree * 2.25)
            mapView.setRegion(region, animated: true)
        } else {
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    // MARK: - IBAction
    
}

extension MapViewController: MKMapViewDelegate {}
