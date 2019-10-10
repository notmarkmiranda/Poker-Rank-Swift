//
//  User.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 10/9/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import Foundation

struct User: Codable {
  var email: String
  var displayName: String?
  var uid: String?
  
  func createDictionary() -> [String: Any] {
    let dict: [String: Any] = [
      "email": self.email,
      "displayName": self.displayName ?? ""
    ]
    return dict
  }
}
