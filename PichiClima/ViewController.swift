//
//  ViewController.swift
//  PichiClima
//
//  Created by Ernesto Cambuston on 10/3/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController {
  var _weather:Weather?
  var lastLocation:CLLocation?
  var locationManager = CLLocationManager()
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    switch CLLocationManager.authorizationStatus() {
    case .AuthorizedWhenInUse:
      locationManager.startUpdatingLocation()
    case .Restricted, .Denied:
      noGps()
    default:
      requestGpsPermissions()
    }
  }

  func serverError() {
    toast("INTERNAL SERVER ERROR.")
  }

  func networkError() {
    toast("Network appears to be down, please connect to the internet and try again.")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  private func noGps() {
    toast("Gps not available.")
  }
  private func requestGpsPermissions() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  private func requestData(coordinate:CLLocationCoordinate2D) {
    Alamofire.request(.GET, "https://weatherapi.herokuapp.com/weather/\(coordinate.latitude)/\(coordinate.longitude)").responseJSON(completionHandler: { [weak self] _, response, object in
      if let object = object.value {
        self?.handleResponse(object)
      } else {
        self?.networkError()
      }
    })
  }
  func handleResponse(object:AnyObject) {
    let json = JSON(object)["current"]
    let farenheit = json["temperature"]["farenheit"].doubleValue
    let celcius = json["temperature"]["celcius"].doubleValue
    let icon = json["icon"].stringValue
    let humidity = json["humidity"].doubleValue
    let condition = json["condition"].stringValue
    var messages = [String]()
    for (_, subJson) in json["messages"]["neutral"] {
      messages.append(subJson.stringValue)
    }
    let weather = Weather(humidity: humidity, icon: icon, description: condition, messages: messages)
    _weather = weather
    toast("Frase: \(messages.last), cel: \(celcius)")
  }
}

extension ViewController:CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      if let lastLocation = lastLocation {
        if location.distanceFromLocation(lastLocation) >= 100 {
          requestData(location.coordinate)
        } else {
          print("Locations to similar to last one..")
        }
      } else {
        requestData(location.coordinate)
      }
    }
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      manager.startUpdatingLocation()
    } else {
      toast("You won't be able to see location.. Go to settings and change location preferences.")
    }
  }
}

extension UIViewController {
  func toast(message:String) {
    let alertController = UIAlertController(title: "Hey..", message: message, preferredStyle: .Alert)
    let alertAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
    alertController.addAction(alertAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
}
