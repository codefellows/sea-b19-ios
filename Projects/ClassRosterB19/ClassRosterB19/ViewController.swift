//
//  ViewController.swift
//  ClassRosterB19
//
//  Created by John Clem on 7/21/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var people : Array<Person>!
    @IBOutlet var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        people = Person.defaultPeopleArray()
        tableView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDataSource
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let personForRow = people[indexPath.row]
        
        cell.textLabel.text = personForRow.firstName
        cell.detailTextLabel.text = personForRow.lastName
        
        return cell
    }
}

