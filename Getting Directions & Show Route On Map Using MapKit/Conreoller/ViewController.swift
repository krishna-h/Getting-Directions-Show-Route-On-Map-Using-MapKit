//
//  ViewController.swift
//  Getting Directions & Show Route On Map Using MapKit
//
//  Created by Mac on 01/08/20.
//  Copyright © 2020 Gunde Ramakrishna Goud. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var textFieldForAddress: UITextField!
    @IBOutlet weak var getDirection: UIButton!
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    var route: MKRoute!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        // Do any additional setup after loading the view.
    }


    @IBAction func onGetDirectionBtn(_ sender: UIButton) {
        getAddress()
    }
    func getAddress()
    {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(textFieldForAddress.text!) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else{
                    print("No Location Found")
                    return
            }
            print(location)
            self.mapthis(destinationCord: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func mapthis(destinationCord: CLLocationCoordinate2D)
    {
        let sourceCordinate = (locationManager.location?.coordinate)!
        let pin = MKPointAnnotation()
        pin.coordinate = sourceCordinate
        map.addAnnotation(pin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
       /* let pin1 = MKPointAnnotation()
        pin1.coordinate = destinationCord
        map.addAnnotation(pin1)*/
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error{
                    print("Something is wrong :\(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
        
    }
}

