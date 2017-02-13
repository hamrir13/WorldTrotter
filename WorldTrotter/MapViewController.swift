//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Bobby Hamrick on 2/2/17.
//  Copyright © 2017 Bobby Hamrick. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
 
    //delcare variable to later create map view
    var mapView: MKMapView!
    
    //declare variable for finding users location
    var locationManager: CLLocationManager!
    
    //button used to access user location
    let locationButton = UIButton()
    
    //hold the user locatoin
    var userLocation: MKUserLocation!
    //holds the latitude coordinate of the user
    var userLat: Double?
    //holds the longitude coordinate of the user
    var userLong: Double?
    
    //variable used to shift through array of pinned locations
    var i: Int = 0
    
    override func loadView() {
        
        //create a map view
        mapView = MKMapView()
        mapView.delegate = self
        
        //initialize locationManager variable
        locationManager = CLLocationManager()
        
        //set it as the view of the controller
        view = mapView
        
        //set the users location to 0
        userLat = 0.0
        userLong = 0.0
        
        //set i to -1 to start at beginning of array
        i = -1
        
        //programmatically create constraints
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
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
        let locationButton = UIButton(frame: CGRect(x: 30, y: 470, width: 50, height: 50))
        //make the button circular
        locationButton.layer.cornerRadius = 0.5 * locationButton.bounds.size.width
        //set the title of the button
        locationButton.setImage(UIImage(named: "locateme.png"), for: .normal)
        //set the background color of the button
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        //when the button is pushed find the location
        locationButton.addTarget(self, action: #selector(MapViewController.findLocation(_:)), for: .touchUpInside)
        //add the button to the view
        view.addSubview(locationButton)
        
        
        //declare a button to initiate moving to the next pin Location
        let nextLoc = UIButton(frame: CGRect(x: 290, y: 470, width: 50, height: 50))
        //make the button circular
        nextLoc.layer.cornerRadius = 0.5 * locationButton.bounds.size.width
        //set the title of the button
        nextLoc.setImage(UIImage(named: "pin.png"), for: .normal)
        //set the background color of the button
        nextLoc.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        //when the button is pushed find the location
        nextLoc.addTarget(self, action: #selector(MapViewController.nextPinLocation(_:)), for: .touchUpInside)
        //add the button to the view
        view.addSubview(nextLoc)
        
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch(segControl.selectedSegmentIndex){
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    //func findLocation(UIButton)
    //When "find me" button is clicked after the view is loaded
    //the app will get access to location and start showing the user's location
    //then will start updating the users location (if he/she moves)
    func findLocation(_ sender: UIButton){
        //change the image of the button just hit to revert
        //so we can go back to the original map view
        sender.setImage(UIImage(named: "revert.png"), for: .normal)
        sender.addTarget(self, action: #selector(MapViewController.revert(_:)), for: .touchUpInside)
        //set the delegate to the MapViewController
        locationManager.delegate = self
        //set accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //request location services
        locationManager.requestWhenInUseAuthorization()
        //show the users location
        mapView.showsUserLocation = true
        //show and zoom on users location
        locationManager.startUpdatingLocation()
    }
    
    //func locationManager(CLLocationMananger, CLLocation)
    //when the .startUpdatingLocation() function is called this function
    //is repeatedly called to keep up with user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //stop updating the location so we can change the camera view of the map
        locationManager.stopUpdatingLocation()
        //get the users location
        let userLocation: CLLocation = locations[0]
        userLat = userLocation.coordinate.latitude
        userLong = userLocation.coordinate.longitude
        //set the degress of the latitude and longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        //make a span of the users location
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //get the longitude and latitude coords of the user
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLat!, userLong!)
        //declare the region that the user is in to adjust the view
        let region: MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        //set the region
        mapView.setRegion(region, animated: false)
    }
    
    func revert(_ sender: UIButton){
        loadView()
    }

    func nextPinLocation(_ sender: UIButton){
        
        let bornLat: Double = 38.9757
        let bornLong: Double = -77.6419
        //create pin to drop on hometown
        let bornPin = MKPointAnnotation()
        //set the location of the pin to the users location
        bornPin.coordinate.latitude = bornLat
        bornPin.coordinate.longitude = bornLong
        //set the title of the pin
        bornPin.title = "My hometown"
        //add the pin to the map
        mapView.addAnnotation(bornPin)
        
        let funLat: Double = 51.5833
        let funLong: Double = -0.1833
        //create pin to drop on interesting location
        let funPin = MKPointAnnotation()
        //set the location of the pin to the users location
        funPin.coordinate.latitude = funLat
        funPin.coordinate.longitude = funLong
        //set the title of the pin
        funPin.title = "My hometown"
        //add the pin to the map
        mapView.addAnnotation(funPin)
        
        let roundHillLat: Double = 18.4587
        let roundHillLong: Double = -78.0113
        //Create a pin to drop users location
        let roundHill = MKPointAnnotation()
        //set the location of the pin to the users location
        roundHill.coordinate.latitude = roundHillLat
        roundHill.coordinate.longitude = roundHillLong
        //set the title of the pin
        roundHill.title = "My Current Location"
        //add the pin to the map
        mapView.addAnnotation(roundHill)
        
        var locArray: [Double]
        
        if userLat == 0.0 {
            locArray = [bornLat, bornLong,
                        funLat, funLong,
                        roundHillLat, roundHillLong
            ]
            
            if i <= 3 {
                i += 2
                print(i)
                if i == 5 {
                    sender.addTarget(self, action:#selector(MapViewController.revert(_:)), for: .touchUpInside)
                }
            }
        }else{
            locArray = [bornLat, bornLong,
                        funLat, funLong,
                        roundHillLat, roundHillLong,
                        userLat!, userLong!
            ]
            
            if i <= 5{
                i += 2
            }else{
                i = 1
            }
        }

        //set the degress of the latitude and longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        //make a span of the users location
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //get the longitude and latitude coords of the user
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locArray[i-1], locArray[i])
        //declare the region that the user is in to adjust the view
        let region: MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        //set the region
        mapView.setRegion(region, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
    }
}
