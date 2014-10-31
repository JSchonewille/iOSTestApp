//
//  Ibeacon.swift
//  iBeacons
//
//  Created by Leo van der Zee on 10-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

import UIKit
import CoreLocation


class Ibeacon: NSObject, CLLocationManagerDelegate {

    var id : Int = 0
    var manufacturer = ""
    var uuid : NSUUID = NSUUID()
    var major : Int = 0
    var minor : Int = 0

    
    func createNewBeaconWithID (id : Int ,name : NSString, UUID : NSString, major : Int, minor : Int) {
        self.id = id;
        self.manufacturer = name
        self.uuid = NSUUID(UUIDString: UUID)!
        self.major = major;
        self.minor = minor;
    }
    
    func getName () -> NSString{
        return manufacturer
    }
    
    func getUUIDtoString () -> NSString{
        return uuid.UUIDString
    }
    
    func getUUID () -> NSUUID{
        return uuid
    }
    
    func getMajor () -> Int{
        return major
    }
    
    func getMinor () -> Int{
        return minor
    }

}
