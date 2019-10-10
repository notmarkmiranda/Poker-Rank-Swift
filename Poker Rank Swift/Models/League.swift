//
//  League.swift
//  Poker Rank Swift
//
//  Created by Mark Miranda on 9/26/19.
//  Copyright © 2019 Mark Miranda. All rights reserved.
//

import Foundation

struct League: Codable {
    var name: String
    var location: String?
    var public_league: Bool
    var user_id: String
    var id: String?
    
    func createDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "name": self.name,
            "location": self.location ?? "",
            "public_league": self.public_league,
            "user_id": self.user_id
        ]
        return dict
    }
}
