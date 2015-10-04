//
//  Array.swift
//  PichiClima
//
//  Created by Ernesto Cambuston on 10/3/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import Foundation

extension Array {
  var random:Element {
    get {
      let array = self
      let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
      return array[randomIndex]
    }
  }
}