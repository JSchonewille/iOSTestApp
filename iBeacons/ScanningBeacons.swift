//
//  ScanningBeacons.swift
//  iBeacons
//
//  Created by Leo van der Zee on 03-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class ScanningBeacons: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet var buttonStart: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelTimer: UILabel!
    
    
    @IBAction func buttonStartPressed(sender: AnyObject)
    {
        csvFile = ""
        areWeLogging = true
        popup()
        
    }
    
    
    
    
    func popup()
    {
        var refreshAlert = UIAlertController(title: "Logging", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Stop", style: .Default, handler: { (action: UIAlertAction!) in
        self.areWeLogging = false
        
        //send mail
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
        self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        mailComposeViewController
        self.csvFile = ""
        } else {
        self.showSendMailErrorAlert()
        }
        
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        // setup mail
        let date = getCurrentTime()
        mailComposerVC.setToRecipients(["sanderwubs@gmail.com"])
        mailComposerVC.setSubject("Logfile iBeacons" + date)
        mailComposerVC.setMessageBody(csvFile, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func getCurrentTime() -> String {
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        var stringValue = formatter.stringFromDate(date)
        
        return stringValue
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved.value:
            NSLog("Mail saved")
        case MFMailComposeResultSent.value:
            NSLog("Mail sent")
        case MFMailComposeResultFailed.value:
            NSLog("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
    
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    var uuid = ""
    var beacons: [CLBeacon]?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var areWeLogging = false
    var csvFile = ""
    
    override func viewDidLoad() {
            super.viewDidLoad()
            let uuidString = uuid
            let beaconIdentifier = "iBeaconModules.us"
            let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)
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
                self.tableView.reloadData()
                
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
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Potentially incomplete method implementation.
            // Return the number of sections.
            return 1
        }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if (beacons != nil)
            {
                return beacons!.count
            }
            else
            {
                return 0
            }
        }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let id = "ScanningBeaconsCell"
            let cell = tableView.dequeueReusableCellWithIdentifier("ScanningBeaconsCell", forIndexPath: indexPath) as ScanningBeaconsCell //or your custom class
            
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
            
            cell.labelProximityOutput!.text = proximityLabel
            cell.labelMajorOutput!.text = String(beacon.major.integerValue)
            cell.labelMinorOutput!.text = String(beacon.minor.integerValue)
            cell.labelRSSIOutput!.text = String(beacon.rssi as Int)
        
            let stringMajor = String(beacon.major.integerValue)
            let stringMinor = String(beacon.minor.integerValue)
            let stringProximity = proximityLabel
            let stringRSSI = String(beacon.rssi as Int)
        
        
            if areWeLogging
            {
                if csvFile.isEmpty
                {
                    csvFile = "Major, Minor, Proximity, RSSI \n"
                }
                csvFile +=
                    stringMajor + ", " + stringMinor + ", " + stringProximity + ", " + stringRSSI + "\n"
            }
            
            return cell
        }
        
        
}
