//
//  ListBeacons.swift
//  iBeacons
//
//  Created by Leo van der Zee on 01-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

import UIKit

class ListBeacons: UIViewController {

    @IBOutlet var labelLog: UILabel!
    @IBOutlet var switchLog: UISwitch!
    @IBOutlet var tableView: UITableView!
    var arrayUUID: [String] = []
    var arrayNaam: [String] = []
    
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue)
    {
        let addBeacon : AddBeacon = segue.sourceViewController as AddBeacon
        let uuid = addBeacon.textFieldUUID.text
        let naam = addBeacon.textFieldNaamFabrikant.text
        
        
        if (countElements(naam) != 0 && countElements(uuid) != 0)
        {
            self.arrayNaam.append(naam)
            self.arrayUUID.append(uuid)
            
            save()
            tableView.reloadData()
            
            //tableView.beginUpdates()
            //tableView.insertRowsAtIndexPaths(indexpath, withRowAnimation: UITableViewRowAnimation.Automatic)
            //tableView.endUpdates()
            //self. saveData
            
        }
    }
    
    func save ()
    {
        var db: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        db.setObject(arrayNaam, forKey: "arrayName")
        db.setObject(arrayUUID, forKey: "arrayUUID")
        db.synchronize()
    }
    
    func load ()
    {
        var db: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let returnValue = db.objectForKey("arrayUUID") as? [String]
        
        if returnValue == nil {
            
        }
        else
        {
            arrayNaam = db.objectForKey("arrayName") as [String]
            arrayUUID = db.objectForKey("arrayUUID") as [String]
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func deleteDatabase(){
        var db :  NSUserDefaults  = NSUserDefaults .standardUserDefaults()
        db.removeObjectForKey("arrayName")
        db.removeObjectForKey("arrayUUID")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrayUUID.isEmpty{
            return 0
        }
        else
        {
            return arrayUUID.count
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let id = "ListBeaconCell"
        
        var cell: ListBeaconCell = tableView.dequeueReusableCellWithIdentifier(id) as ListBeaconCell
        
        cell.labelNaamOutput.text = arrayNaam[indexPath.row]
        cell.labelUuidOutput.text = arrayUUID[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            arrayUUID.removeAtIndex(indexPath.item)
            arrayNaam.removeAtIndex(indexPath.item)
            save()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ScanningBeacons") {
            let view: ScanningBeacons = segue.destinationViewController as ScanningBeacons
            let indexpath = tableView.indexPathForSelectedRow()
            view.uuid = arrayUUID[indexpath!.row]
        }
    }



}
