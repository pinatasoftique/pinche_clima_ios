//
//  TodayViewController.swift
//  PeachyToday
//
//  Created by Ricardo Gonzalez on 11/10/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
  
  var weather: Weather? = nil
  var lastLocation:CLLocation?
  var locationManager = CLLocationManager()
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
      // Do any additional setup after loading the view from its nib.
    locationManager.delegate = self
    switch CLLocationManager.authorizationStatus() {
    case .Restricted, .Denied:
      noGps()
    default:
      locationManager.startUpdatingLocation()
    }
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
    
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
    if let location = lastLocation {
      requestData(location.coordinate)
    }
    completionHandler(NCUpdateResult.NewData)
  }
  
  func handleResponse(weather:Weather) {
    messageLabel.text = weather.messages
    temperatureLabel.text = "\(weather.celsius)° C"
  }
  
  private func requestData(coordinate:CLLocationCoordinate2D) {
    Weather.current(coordinate, completion: { [weak self] weather in
      self?.weather = weather
      self?.handleResponse(weather)
      }, error: { [weak self] error in
        self?.temperatureLabel.text = ""
        self?.messageLabel.text = "Error al obtener el clima"
      })
  }
  
  private func noGps() {
    self.temperatureLabel.text = ""
    self.messageLabel.text = "No se puede obtener la ubicación"
  }
  private func requestGpsPermissions() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    manager.stopUpdatingLocation()
    if let location = locations.last {
      if let lastLocation = lastLocation {
        if location.distanceFromLocation(lastLocation) >= 1000 {
          requestData(location.coordinate)
        } else {
          print("Locations to similar to last one..")
        }
      } else {
        lastLocation = location
        requestData(location.coordinate)
      }
    }
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      manager.startUpdatingLocation()
    } else if status != .NotDetermined {
      noGps()
    }
  }
    
}
