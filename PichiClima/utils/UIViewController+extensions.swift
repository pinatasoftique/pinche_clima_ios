//
//  UIViewController+extensions.swift
//  PichiClima
//
//  Created by Ernesto Cambuston on 10/3/15.
//  Copyright © 2015 Ernesto Cambuston. All rights reserved.
//

import UIKit

extension UIViewController {
  func toast(message:String) {
    let alertController = UIAlertController(title: "Hey..", message: message, preferredStyle: .Alert)
    let alertAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
    alertController.addAction(alertAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
}