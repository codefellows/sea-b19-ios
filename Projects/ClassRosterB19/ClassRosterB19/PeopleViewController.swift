//
//  ViewController.swift
//  ClassRosterB19
//
//  Created by Bradley Johnson on 7/21/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDataSource {
    
    var people = Person.loadPeopleFromPlist()
    
    @IBOutlet var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView!.dataSource = self
        
        self.navigationController.navigationItem.title = "People"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView?.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath) as UITableViewCell

        let personForRow = people[indexPath.row]
        cell.textLabel.text = personForRow.fullName()

        println("dequeue reusable cell")
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destinationViewController as DetailViewController
            destination.person = people[tableView!.indexPathForSelectedRow().row]
        } else if segue.identifier == "ShowNewPerson" {
            let destination = segue.destinationViewController as DetailViewController
            let newPerson = Person(firstName: "", lastName: "")
            people.append(newPerson)
            destination.person = newPerson
        }
    }
    
    
    
    
    
    
    
}

