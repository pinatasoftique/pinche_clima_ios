//
//  Weather.swift
//  PichiClima
//
//  Created by Ernesto Cambuston on 10/3/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import Foundation

typealias Temperature = (farenheit:Double, celcius:Double)

struct Weather {
  var humidity:Double
  var icon:String
  var description:String
  var messages:[String]
}