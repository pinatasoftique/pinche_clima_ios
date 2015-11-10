//
//  ViewController.swift
//  PichiClima
//
//  Created by Ernesto Cambuston on 10/3/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var conditionLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!

  var _weather:Weather?
  var lastLocation:CLLocation?
  var locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    self.navigationController?.navigationBar.barStyle = .BlackTranslucent;
    locationManager.delegate = self
    switch CLLocationManager.authorizationStatus() {
    case .NotDetermined:
      requestGpsPermissions()
    case .Restricted, .Denied:
      noGps()
    default:
      locationManager.startUpdatingLocation()
    }
  }
    
  override func viewWillAppear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    super.viewWillDisappear(animated)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
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
    Weather.current(coordinate, completion: { [weak self] weather in
      self?.handleResponse(weather)
    }, error: { [weak self] error in
      self?.toast("Network or server error.")
    })
  }
  
  func handleResponse(weather:Weather) {
    messageLabel.text = weather.messages
    conditionLabel.text = weather.condition
    imageView.image = UIImage(named: weather.icon)
    backgroundImageView.image = UIImage(named: weather.background)
    temperatureLabel.text = "\(weather.celsius)° C"
  }
}

extension ViewController:CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    manager.stopUpdatingLocation()
    if let location = locations.last {
      if let lastLocation = lastLocation {
        if location.distanceFromLocation(lastLocation) >= 10000 {
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
    } else if status != .NotDetermined {
      toast("You won't be able to see location.. Go to settings and change location preferences.")
    }
  }
}


