//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Bobby Hamrick on 2/2/17.
//  Copyright © 2017 Bobby Hamrick. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
 
    //delcare variable to later create map view
    var mapView: MKMapView!
    
    //button used to access user location
    let locationButton = UIButton()
    
    //variable used to shift through array of pinned locations
    var i: Int = 0
    
    override func loadView() {
        
        //create a map view
        mapView = MKMapView()
        mapView.delegate = self
        
        //initialize locationManager variable
        //declare variable for finding users location
        let locationManager: CLLocationManager = CLLocationManager()
        //request location services
        locationManager.requestWhenInUseAuthorization()
        
        //set it as the view of the controller
        view = mapView
        
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
        //add constraint
        locationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -250)
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
        //add constraint
        locationButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -250)
        //when the button is pushed find the location
        nextLoc.addTarget(self, action: #selector(MapViewController.dropNextPinLocation(_:)), for: .touchUpInside)
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
        //show the users location
        mapView.showsUserLocation = true //this calls mapView function below to get users location
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //define a span for zooming in on user's loc
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        //make a span of the users location
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //get the longitude and latitude coords of the user
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude,
                                                                     mapView.userLocation.coordinate.longitude)
        //declare the region that the user is in to adjust the view
        let region: MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        //set the region
        mapView.setRegion(region, animated: false)
    }
    
    //fun revert(UIButton)
    //reset the view to default by calling the loadView() func
    func revert(_ sender: UIButton){
        loadView()
    }
    
    //func dropNextPinLocation(UIButton)
    //when the pin button is tapped drop a pin on the POI
    func dropNextPinLocation(_ sender: UIButton){

        //create pin variable by calling create pin func
        let pin = createPins()
        //add the pin to the view
        mapView.addAnnotation(pin)
        
        //once all POI have been pinned, set the target of the pin button 
        //to revert to reset the view to default
        if i == 5 {
            sender.addTarget(self, action:#selector(MapViewController.revert(_:)), for: .touchUpInside)
        }

        //-- set the camera to be zoomed in on pin --
        //set the degress of the latitude and longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        //make a span of the users location
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //get the longitude and latitude coords of the user
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pin.coordinate.latitude, pin.coordinate.longitude)
        //declare the region that the user is in to adjust the view
        let region: MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        //set the region
        mapView.setRegion(region, animated: false)
    }
    
    //func createPins()
    //create the specifics of the pins that need to be dropped
    //return the pin to the dropNextPinLocation func
    func createPins() -> MKPointAnnotation {
        //create array of all lat and long coords of POI
        let pinCoords: [Double] = [38.9757, -77.6419, 51.5833, -0.1833, 18.4587, -78.0113]
        
        //-- set the lat and long to correct pair in array --
        if i<=3 {
            i+=2
        }
        let curLat: Double = pinCoords[i-1]
        let curLong: Double = pinCoords[i]
        
        //create pin to drop on hometown
        let newPin = MKPointAnnotation()
        //set the location of the pin to the users location
        newPin.coordinate.latitude = curLat
        newPin.coordinate.longitude = curLong

        return newPin

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
    }
}
