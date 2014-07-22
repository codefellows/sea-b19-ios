// Playground - noun: a place where people can play

import UIKit

class Person {
    
    var firstName : String
    var lastName : String
    
    init(firstName : String, lastName : String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    class func defaultPeopleArray() -> Array<Person> {
        var people = Array<Person>()
        for idx in 0...12 {
            let firstName = "Person"
            let lastName = "#\(idx)"
            let newPerson = Person(firstName: firstName, lastName: lastName)
            people += newPerson

        }
        return people
    }
}

class DataSource : NSObject, UITableViewDataSource {
    
    @lazy var people = Person.defaultPeopleArray()
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let personForRow = people[indexPath.row]
        cell.textLabel.text = personForRow.firstName
        cell.textLabel.text = personForRow.lastName
        
        return cell
    }
}

class TableViewController {

    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 568), style: UITableViewStyle.Grouped)
    @lazy var dataSource = DataSource()
    
    func loadData() {
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

let tableVC = TableViewController()
tableVC.loadData()
