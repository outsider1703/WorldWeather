//
//  UIMapView+extension.swift
//  WorldWeather
//
//  Created by Macbook on 02.11.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import MapKit

extension MKMapView {
    func centerLocation(_ location: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 30000) {
        let coordinateRagion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRagion, animated: true)
    }
}
