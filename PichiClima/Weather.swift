//
//  Weather.swift
//  PichiClima
//
//  Created by Ernesto Cambuston on 10/3/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Alamofire
import CoreLocation

class Weather:Object {
  dynamic var humidity = 0.0
  dynamic var icon = ""
  dynamic var condition = ""
  dynamic var messages = ""
  dynamic var farenheit = 0.0
  dynamic var celcius = 0
  dynamic var date = NSDate()
  dynamic var background = "back"
  
  class func fromJson(object:AnyObject)->Weather {
    let weather = Weather()
    let json = JSON(data: object as! NSData)["current"]
    if let farenheit = json["temperature"]["farenheit"].double {
      weather.farenheit = farenheit
    }
    if let celcius = json["temperature"]["celcius"].int {
      weather.celcius = celcius
    }
    if let icon = json["icon"].string {
      weather.icon = icon
    }
    if let humidity = json["humidity"].double {
      weather.humidity = humidity
    }
    if let condition = json["condition"].string {
      weather.condition = condition
    }
    var messages = [String]()
    for (_, subJson) in json["messages"]["neutral"] {
      if let message = subJson.string {
        messages.append(message)
      }
    }
    weather.messages = messages.random
    if weather.isNight(){
      weather.background = "back_night"
      weather.icon = "nt_\(weather.icon)"
    }else{
      weather.background = "back"
    }
    return weather
  }
  
  class func current(coordinate:CLLocationCoordinate2D , completion:(weather:Weather)->(), error:(error:ErrorType)->())->Alamofire.Request {
    return Alamofire.request(.GET, "https://weatherapi.herokuapp.com/weather/\(coordinate.latitude)/\(coordinate.longitude)").responseJSON{ response in
      if let object = response.data {
        let realm = try! Realm()
        let user = User.current
        let weather = Weather.fromJson(object)
        try! realm.write {
            user.weathers.append(weather)
        }
        completion(weather: weather)
      } else {
        error(error: NSError(domain: "unknown error", code: 100, userInfo: nil))
      }
      }
  }
  
  func isNight() -> Bool {
    let calendar = NSCalendar.currentCalendar()
    let comp = calendar.components([.Hour, .Minute], fromDate: self.date)
    if(comp.hour > 19 || comp.hour < 5){
      return true
    }else{
      return false
    }
  }
}