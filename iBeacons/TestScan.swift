//
//  TestScan.swift
//  iBeacons
//
//  Created by Leo van der Zee on 01-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

import UIKit
import CoreLocation

class TestScan: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{

    
    @IBOutlet var tableView: UITableView!
    var beacons: [CLBeacon]?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    
    @IBOutlet var labelEnd: UILabel!
    @IBOutlet var buttonStart: UIButton!
    @IBOutlet var buttonStop: UIButton!
    var startTime = NSTimeInterval()
    var timer : NSTimer = NSTimer()



    
    @IBAction func startPressed(sender: AnyObject) {
        if !timer.valid
        {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
        
    }
    
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        labelEnd.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uuidString = "EBEFD083-70A2-47C8-9837-E7B5634DF524"
        let beaconIdentifier = "iBeaconModules.us"
        let beaconUUID:NSUUID = NSUUID(UUIDBytes: uuidString)
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // beacon functions
    
    func sendLocalNotificationWithMessage(message: String!, playSound: Bool) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        if(playSound) {
            // classic star trek communicator beep
            //	http://www.trekcore.com/audio/
            //
            // note: convert mp3 and wav formats into caf using:
            //	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
            // http://stackoverflow.com/a/10388263
            
            notification.soundName = "tos_beep.caf";
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            self.beacons = beacons as [CLBeacon]?
            NSLog(String(beacons.count))
            tableView!.reloadData()
            
            NSLog("didRangeBeacons")
            var message:String = ""
            
            var playSound = false
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
                
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    message = "You are far away from the beacon"
                    playSound = true
                case CLProximity.Near:
                    message = "You are near the beacon"
                case CLProximity.Immediate:
                    message = "You are in the immediate proximity of the beacon"
                case CLProximity.Unknown:
                    return
                }
            } else {
                
                if(lastProximity == CLProximity.Unknown) {
                    return;
                }
                
                message = "No beacons are nearby"
                playSound = true
                lastProximity = CLProximity.Unknown
            }
            
            NSLog("%@", message)
            sendLocalNotificationWithMessage(message, playSound: playSound)
    }
    
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
            sendLocalNotificationWithMessage("You entered the region", playSound: false)
    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
            sendLocalNotificationWithMessage("You exited the region", playSound: true)
    }

    
    
    
    
    
    
    
    
    
    

    

// table functions

func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
        if(beacons != nil) {
            return beacons!.count
            
        } else {
            println("Geen beacons gevonden")
            return 0
        }
}

func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:TestScanCell? =
        tableView.dequeueReusableCellWithIdentifier("TestScanCell") as? TestScanCell
        /*
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyIdentifier")
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        */
        
        let beacon:CLBeacon = beacons![indexPath.row]
        var proximityLabel:String! = ""
        
        switch beacon.proximity {
        case CLProximity.Far:
            proximityLabel = "Far"
        case CLProximity.Near:
            proximityLabel = "Near"
        case CLProximity.Immediate:
            proximityLabel = "Immediate"
        case CLProximity.Unknown:
            proximityLabel = "Unknown"
        }
        
        cell!.labelProximityOutput!.text = proximityLabel
        cell!.labelMajorOutput!.text = String(beacon.major.integerValue)
        cell!.labelMinorOutput!.text = String(beacon.minor.integerValue)
        cell!.labelRSSIOutput!.text = String(beacon.rssi as Int)
        /*
        let detailLabel:String = "Major: \(beacon.major.integerValue), " +
            "Minor: \(beacon.minor.integerValue), " +
            "RSSI: \(beacon.rssi as Int), " +
        "UUID: \(beacon.proximityUUID.UUIDString)"
        cell!.detailTextLabel!.text = detailLabel
        */
        return cell!
}




    /*
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return major.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let id = "TestScanCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as TestScanCell!
        /*
        if cell == nil {
            //tableView.registerNib(UINib(nibName: "UICustomTableViewCell", bundle: nil), forCellReuseIdentifier: "UICustomTableViewCell")
            tableView.registerClass(TestScanCell.classForCoder(), forCellReuseIdentifier: id)
            
            cell = TestScanCell(coder: TestScanCell.classForCoder())
        }
        */
        
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        }
        
        cell.labelMajorOutput.text = major[indexPath.row]
        cell.labelMinorOutput.text = minor[indexPath.row]
        
        return cell
    }
    */

}
