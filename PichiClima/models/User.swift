//
//  user.swift
//  PichiClima
//
//  Created by Ernesto Cambuston on 10/3/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import Foundation
import RealmSwift

class User:Object {
  dynamic var first_name = ""
  dynamic var last_name = ""
  let weathers = List<Weather>()
  class var current:User {
    get {
      let realm = try! Realm()
      if let user = realm.objects(User.self).first {
        return user
      } else {
        let user = User()
        try! realm.write {
            realm.create(User.self, value: user, update: false)
        }
        return user
      }
    }
  }
}