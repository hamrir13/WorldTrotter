//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Bobby Hamrick on 2/2/17.
//  Copyright © 2017 Bobby Hamrick. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
 
    //delcare variable to later create map view
    var mapView: MKMapView!
    
    //declare variable for finding users location
    var locationManager: CLLocationManager!
    
    var userLocation: MKUserLocation!
    
    override func loadView() {
        
        //create a map view
        mapView = MKMapView()
        
        //initialize locationManager variable
        locationManager = CLLocationManager()
        
        //set it as the view of the controller
        view = mapView
        
        //programmatically create constraints
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        //set the background color
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        //make the selected index start with 0 (Standard)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //create constraints based on anchors
        //create top constraint
        let topContraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        //create margins
        let margins = view.layoutMarginsGuide
        //create constraints for the leading edges
        let leadingContraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        //create constraints for the trailing edges
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        //make each of the constraints active
        topContraint.isActive = true
        leadingContraint.isActive = true
        trailingConstraint.isActive = true
        
        //determine users location
        
        //declare a button to initiate the finding location
        let locationButton = UIButton(frame: CGRect(x: 30, y: 70, width: 80, height: 30))
        //set the title of the button
        locationButton.setTitle("Find Me", for: .normal)
        //set the color of the button
        locationButton.setTitleColor(UIColor.blue, for: .normal)
        //set the background color of the button
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        //when the button is pushed find the location
        locationButton.addTarget(self, action: #selector(MapViewController.findLocation(_:)), for: .touchUpInside)
        //add the button to the view
        view.addSubview(locationButton)
        
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch(segControl.selectedSegmentIndex){
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    func findLocation(_ sender: UIButton){
        locationManager.delegate = self
        //allow location services
        locationManager.requestWhenInUseAuthorization()
        //show the users location
        mapView.showsUserLocation = true
        //show and zoom on users location
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get the users location
        let userLocation: CLLocation = locations[0]
        //set the degress of the latitude and longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        //make a span of the users location
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //get the longitude and latitude coords of the user
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        //declare the region that the user is in to adjust the view
        let region: MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        //set the region
        mapView.setRegion(region, animated: false)
        
        //Create a pin to drop users location
        let pin = MKPointAnnotation()
        //set the location of the pin to the users location
        pin.coordinate.latitude = userLocation.coordinate.latitude
        pin.coordinate.longitude = userLocation.coordinate.longitude
        //set the title of the pin
        pin.title = "Your Location"
        //add the pin to the map
        mapView.addAnnotation(pin)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
    }
}
