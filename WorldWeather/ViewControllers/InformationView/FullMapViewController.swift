//
//  FullMapViewController.swift
//  WorldWeather
//
//  Created by Macbook on 04.11.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import MapKit

class FullMapViewController: UIViewController {
    
    let fullMapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(fullMapView)
        fullMapView.frame = view.bounds
    }
    
     func setLocationForMap(coord: Attraction?) {
        guard let attractionCoord = coord else { return }
        guard let lat = Double(attractionCoord.lat!), let lon = Double(attractionCoord.lon!) else { return }
        
        let initialLocation = CLLocationCoordinate2D(latitude: lat,
                                                     longitude: lon)
        fullMapView.centerLocation(initialLocation, regionRadius: 1000)
        
        let marker = MKPointAnnotation()
        marker.coordinate = initialLocation
        fullMapView.addAnnotation(marker)
    }
}
