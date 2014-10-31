//
//  ListBeacons.swift
//  iBeacons
//
//  Created by Leo van der Zee on 01-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

import UIKit

class ListBeacons: UIViewController {

    @IBOutlet var tableView: UITableView!
    var arrayIbeacons : [Ibeacon] = [Ibeacon]()
    var arrayJSON = NSMutableArray()
    var data : NSString = NSString();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //------------------------ OWN FUNCTIONS -----------------------------
    
    func unwindToSegue (segue : UIStoryboardSegue){
        let addBeacon : AddBeacon = segue.sourceViewController as AddBeacon
        let uuid = addBeacon.textFieldUUID.text
        let naam = addBeacon.textFieldNaamFabrikant.text
        
        
        if (countElements(naam) != 0 && countElements(uuid) != 0)
        {
            var ibeacon = Ibeacon()
            ibeacon.createNewBeaconWithID(0, name: naam, UUID: uuid, major: 0, minor: 0)
            arrayIbeacons.append(ibeacon)

            save()
            tableView.reloadData()
            
            //tableView.beginUpdates()
            //tableView.insertRowsAtIndexPaths(indexpath, withRowAnimation: UITableViewRowAnimation.Automatic)
            //tableView.endUpdates()
            //self. saveData
            
        }
    } // add a beacon screen, save pressed?, go back to this screen
    
    func save (){
        var db: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        db.setObject(arrayIbeacons, forKey: "iBeacon")
        db.synchronize()
    } // save to memory
    
    func deleteDatabase(){
        var db :  NSUserDefaults  = NSUserDefaults .standardUserDefaults()
        db.removeObjectForKey("arrayName")
        db.removeObjectForKey("arrayUUID")
    } // delete in memory
    
    func setUpIbeacons () {
        var ibeacon1 : Ibeacon = Ibeacon()
        ibeacon1.createNewBeaconWithID(0, name: "Estimote", UUID: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 0, minor: 0)
        arrayIbeacons.append(ibeacon1)
        
        var ibeacon2 : Ibeacon = Ibeacon()
        ibeacon2.createNewBeaconWithID(0, name: "Kontakt", UUID: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E", major: 0, minor: 0)
        arrayIbeacons.append(ibeacon2)
    } // test with pre set ibeacons
    
    func retrieveData(){
        
        // zie class json.swift van github: https://github.com/dankogai/swift-json/
        let json = JSON(url:"http://ibeacons.leovdzee.nl/getIbeaconsListToJson.php")
        let j = json.toString()
        //println(json)
        
        print (json["test"][1]["ID"])
        //print ("\n")
        //print (json["test"].length)

        
        for var index = 0; index < json["test"].length; ++index {
            let idString =            String(json["test"][index]["ID"].toString())
            let fabrikantString =     String(json["test"][index]["fabrikant"].toString())
            let uuid =          String(json["test"][index]["uuid"].toString())
            let majorString =         String(json["test"][index]["major"].toString())
            let minorString =         String(json["test"][index]["minor"].toString())
        
            let id = idString.toInt()!
            let fabrikant : NSString = fabrikantString
            let major = majorString.toInt()!
            let minor = minorString.toInt()!
            
        var ibeacon : Ibeacon = Ibeacon();
        ibeacon.createNewBeaconWithID(id, name: fabrikant, UUID: uuid, major: major, minor: minor)
        arrayIbeacons.append(ibeacon)
        }
    } // get data from ibeacons.leovdzee.nl
    
    
    // ------------------------------TABLE--------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayIbeacons.isEmpty{
            return 0
        }
        else
        {
            return arrayIbeacons.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let id = "ListBeaconCell"
        var cell: ListBeaconCell = tableView.dequeueReusableCellWithIdentifier(id) as ListBeaconCell
        var ibeacon : Ibeacon = arrayIbeacons[indexPath.row]
        
        cell.labelNaamOutput.text = ibeacon.getName()
        cell.labelUuidOutput.text = ibeacon.getUUIDtoString()

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            arrayIbeacons.removeAtIndex(indexPath.row)
            save() // save arraylist of beacons to memory again
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if (segue.identifier == "ScanningBeacons") {
            let view: ScanningBeacons = segue.destinationViewController as ScanningBeacons
            let indexpath = tableView.indexPathForSelectedRow()
            let ibeacon : Ibeacon = arrayIbeacons[indexpath!.row]
            view.uuid = ibeacon.getUUID()
        }
    } // go to next screen (overview scanned beacons) if clicked on a cell



}
