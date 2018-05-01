//
//  VilloStation.swift
//  IOS_Werkstuk2
//
//  Created by student on 01/05/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation

class VilloStation {
    var name: String
    var adress: String
    var latitude: Double
    var longitude: Double
    var banking: Bool
    var bonus: Bool
    var status: Bool
    var bikeStands: Int
    var availableBikeStands: Int
    var availableBikes: Int
    
    init(name: String, adress: String, latitude: Double, longitude: Double, banking: Bool, bonus: Bool, status: Bool, bikeStands: Int, availableBikeStands: Int, availableBikes: Int) {
        self.name = name
        self.adress = adress
        self.latitude = latitude
        self.longitude = longitude
        self.banking = banking
        self.bonus = bonus
        self.status = status
        self.bikeStands = bikeStands
        self.availableBikeStands = availableBikeStands
        self.availableBikes = availableBikes
    }
}
