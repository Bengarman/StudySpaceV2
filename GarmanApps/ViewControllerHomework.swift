//
//  ViewControllerHomework.swift
//  GarmanApps
//
//  Created by Ben Garman on 15/02/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//
import UIKit

import CoreData
import CloudKit

struct temp {
    static var teacher = ""
    static var taskName = ""
    static var dueDate = ""
    static var urgency = ""
    static var description = ""
    static var id = ""
    static var objectId = NSManagedObjectID()
}

class ViewControllerHomework: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return notes.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == notes.count{
            return 0
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.section]
        temp.teacher = (note.value(forKeyPath: "subject") as! String)
        temp.taskName = (note.value(forKeyPath: "task") as! String)
        temp.id = note.value(forKeyPath: "recordID") as! String
        temp.objectId = note.objectID
        let temper = (note.value(forKeyPath: "date") as! String)
        let days = daysTill(datee: note.value(forKeyPath: "date") as! String) as! Int
        if days == 1{
            temp.dueDate = temper.dropFirst(9) + " " + (temper.dropFirst(5)).dropLast(2) + " "
            temp.dueDate = temp.dueDate + temper.dropLast(6) + " - " + (String(days) + " day left")
        }else if days < 1 {
            temp.dueDate = temper.dropFirst(9) + " " + (temper.dropFirst(5)).dropLast(2) + " "
            temp.dueDate = temp.dueDate + temper.dropLast(6) + " - " + "Due Now"
        }else{
            temp.dueDate = temper.dropFirst(9) + " " + (temper.dropFirst(5)).dropLast(2) + " "
            temp.dueDate = temp.dueDate + temper.dropLast(6) + " - " + (String(days) + " days left")
        }
        if note.value(forKeyPath: "urgency") as! String == "VeryHigh"{
            temp.urgency = "Very High"
        }else if note.value(forKeyPath: "urgency") as! String == "VeryLow"{
            temp.urgency = "Very Low"
        }else{
            temp.urgency = note.value(forKeyPath: "urgency") as! String
        }
        
        temp.description = note.value(forKeyPath: "description1") as! String
        print("clcicked")
        self.performSegue(withIdentifier: "hwkInfo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0))
            return headerView
        }else{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 27))
            headerView.backgroundColor = UIColor(white: 1, alpha: 0)
            return headerView
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homework", for: indexPath) as! TableViewCellHomework
        let note = notes[indexPath.section]
        switch (note.value(forKeyPath: "urgency") as! String){
        case "Very High" :
            cell.priotiyViewer.image = UIImage(named: "VeryHigh")
            
        case "High":
            cell.priotiyViewer.image = UIImage(named: "High")
        case "Default":
            cell.priotiyViewer.image = UIImage(named: "Default")
        case "Low":
            cell.priotiyViewer.image = UIImage(named: "Low")
        case "Very Low":
            cell.priotiyViewer.image = UIImage(named: "VeryLow")
        default:
            print("Error")
        }
        
        let days = daysTill(datee: note.value(forKeyPath: "date") as! String) as! Int
        if days == 1{
            cell.daysLeft.text = (String(days) + "      day")
        }else if days < 1 {
            cell.daysLeft.text = ("Due Now")
        }else{
            cell.daysLeft.text = (String(days) + " days")
        }
        
        cell.HomeworkName.text = (note.value(forKeyPath: "task") as! String)
        cell.teacher.text = (note.value(forKeyPath: "subject") as! String)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var dropDown: UIButton!
    @IBOutlet weak var sorttypeSelector: UIImageView!
    @IBOutlet weak var sortTypeLabel: UILabel!
    var rotationCounter = 1
    @IBAction func dateAddPressed(_ sender: Any) {
        sorttypeSelector.image = UIImage(named: "dateAddedSort")
        sortTypeLabel.text = "Date Added"
        queryDatabase(type: "dateAdded")
    }
    
    @IBAction func dueDatePressed(_ sender: Any) {
        sorttypeSelector.image = UIImage(named: "dueDateSort")
        sortTypeLabel.text = "Due Date"
        queryDatabase(type: "dueDate")
    }
    
    @IBAction func priorityPressed(_ sender: Any) {
        sorttypeSelector.image = UIImage(named: "prioritySort")
        sortTypeLabel.text = "Priority"
        queryDatabase(type: "urgency")
    }
    
    @IBAction func dropDownPressed(_ sender: Any) {
        if rotationCounter == 0{
            UIView.animate(withDuration: 0.5) {
                self.tableView.frame = CGRect(x: 0, y: 188, width: 375, height: 535)
                self.dropDown.imageView?.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                self.rotationCounter = 1
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.tableView.frame = CGRect(x: 0, y: 288, width: 375, height: 432)
                self.dropDown.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                
                self.rotationCounter = 0
            }
        }
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        queryDatabase(type: "dueDate")
        print(notes)
        print("should be here")
    }
    
    var notes: [NSManagedObject] = []
    let database = CKContainer.default().privateCloudDatabase
    
    
    func queryDatabase(type: String){
        if type == "dueDate"{
            let managedContext = GlobalVariables.managedContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Homework")
            let sort = NSSortDescriptor(key: #keyPath(Homework.accDate), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            fetchRequest.returnsObjectsAsFaults = false
            do {
                self.notes = try managedContext.fetch(fetchRequest)
                tableView.reloadData()
                print(notes)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else if type == "dateAdded"{
            let managedContext = GlobalVariables.managedContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Homework")
            let sort = NSSortDescriptor(key: #keyPath(Homework.creationDate), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            fetchRequest.returnsObjectsAsFaults = false
            do {
                self.notes = try managedContext.fetch(fetchRequest)
                tableView.reloadData()
                print(notes)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else{
            self.notes.removeAll()
            let managedContext = GlobalVariables.managedContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Homework")
            var predicate:NSPredicate = NSPredicate(format: "urgency = 'Very High'")
            fetchRequest.predicate = predicate
            let sort = NSSortDescriptor(key: #keyPath(Homework.accDate), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let temp = try managedContext.fetch(fetchRequest)
                self.notes = self.notes + temp
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            predicate = NSPredicate(format: "urgency = 'High'")
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let temp = try managedContext.fetch(fetchRequest)
                self.notes = self.notes + temp
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            predicate = NSPredicate(format: "urgency = 'Default'")
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let temp = try managedContext.fetch(fetchRequest)
                self.notes = self.notes + temp
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            predicate = NSPredicate(format: "urgency = 'Low'")
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let temp = try managedContext.fetch(fetchRequest)
                self.notes = self.notes + temp
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            predicate = NSPredicate(format: "urgency = 'Very Low'")
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let temp = try managedContext.fetch(fetchRequest)
                self.notes = self.notes + temp
                tableView.reloadData()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        
        
       
    }
    var recordID = ""
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "homework", for: indexPath) as! TableViewCellHomework
            cell.backgroundColor = UIColor.init(red: 178/255, green: 10/255, blue: 10/255, alpha: 1)
            
            let managedContext = GlobalVariables.managedContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Homework")
            let note = self.notes[indexPath.section]
            

            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let people = try managedContext.fetch(fetchRequest)
                for item in people{
                    if item.objectID == note.objectID{
                        print("this one")
                        self.recordID = item.value(forKeyPath: "recordID") as! String
                        let managedObjectData:NSManagedObject = item as! NSManagedObject
                        managedContext.delete(managedObjectData)
                    }
                    
                }
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            
            do {
                try managedContext.save()
                self.view.endEditing(true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            let database = CKContainer.default().privateCloudDatabase
            let myID = CKRecord.ID(recordName: self.recordID)
            
            database.delete(withRecordID: myID) { (recordID, error) -> Void in
                guard let recordID = recordID else {
                    print("Error deleting record: ")
                    return
                }
                print("Successfully deleted record: ",
                      recordID.recordName)
            }
            
            if self.sortTypeLabel.text == "Due Date"{
                self.queryDatabase(type: "dueDate")
            }else if self.sortTypeLabel.text == "Date Added"{
                self.queryDatabase(type: "dateAdded")
            }else if self.sortTypeLabel.text == "Priority"{
                self.queryDatabase(type: "urgency")
            }
            
            self.tableView.reloadData()
            
        }
        delete.backgroundColor = UIColor.init(red: 178/255, green: 10/255, blue: 10/255, alpha: 1)
        //delete.backgroundColor = UIColor(patternImage:UIImage(named: "Rectangle13")!)
        
        return [delete]
    }

}
