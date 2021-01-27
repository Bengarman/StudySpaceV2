//
//  ViewControllerFirstTimeSplash.swift
//  GarmanApps
//
//  Created by Ben Garman on 27/06/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class ViewControllerFirstTimeSplash: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func restoreClicked(_ sender: Any) {
        //splashRestore
        GlobalVariables.reload = true
        self.performSegue(withIdentifier: "splashRestore", sender: nil)
        //queryDatabase2()
    }
    
    
    let database = CKContainer.default().privateCloudDatabase
    func queryDatabase2(){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let database = CKContainer.default().privateCloudDatabase
            self.deleteAllData(entity: "Homework")
            
            let query = CKQuery(recordType: "Homework", predicate: NSPredicate(value: true))
            database.perform(query, inZoneWith: nil) { (records, _) in
                var notes = [CKRecord]()
                guard let records = records else{return}
                notes = records
                print(notes)
                var counter = notes.count
                while counter > 0{
                    let entity = NSEntityDescription.entity(forEntityName: "Homework",
                                                            in: managedContext)!
                    let person = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
                    
                    
                    person.setValue(String(notes[counter - 1].recordID.recordName), forKeyPath: "recordID")
                    
                    let temp = notes[counter - 1].value(forKey: "date") as! String
                    var dateComponents = DateComponents()
                    dateComponents.year = Int(temp.dropLast(6))!
                    let x = (temp.dropLast(2)).dropFirst(5)
                    if x == "Jan"{
                        dateComponents.month = 1
                    }else if x == "Feb"{
                        dateComponents.month = 2
                    }else if x == "Mar"{
                        dateComponents.month = 3
                    }else if x == "Apr"{
                        dateComponents.month = 4
                    }else if x == "May"{
                        dateComponents.month = 5
                    }else if x == "Jun"{
                        dateComponents.month = 6
                    }else if x == "Jul"{
                        dateComponents.month = 7
                    }else if x == "Aug"{
                        dateComponents.month = 8
                    }else if x == "Sep"{
                        dateComponents.month = 9
                    }else if x == "Oct"{
                        dateComponents.month = 10
                    }else if x == "Nov"{
                        dateComponents.month = 11
                    }else{
                        dateComponents.month = 12
                    }
                    dateComponents.day = Int(temp.dropFirst(9))
                    dateComponents.timeZone = TimeZone(abbreviation: "UTC")
                    
                    let userCalendar = Calendar.current
                    let someDateTime = userCalendar.date(from: dateComponents)
                    
                    person.setValue(someDateTime, forKeyPath: "accDate")
                    person.setValue(notes[counter - 1].value(forKey: "creationDate") as! String, forKeyPath: "creationDate")
                    person.setValue(notes[counter - 1].value(forKey: "urgency") as! String, forKeyPath: "urgency")
                    person.setValue(notes[counter - 1].value(forKey: "date") as! String, forKeyPath: "date")
                    person.setValue(notes[counter - 1].value(forKey: "task") as! String, forKeyPath: "task")
                    person.setValue(notes[counter - 1].value(forKey: "subject") as! String, forKeyPath: "subject")
                    person.setValue(notes[counter - 1].value(forKey: "description") as! String, forKeyPath: "description1")
                    do {
                        try managedContext.save()
                        counter = counter - 1
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
                print("should i be here")
                
            }
            
            let database2 = CKContainer.default().privateCloudDatabase
            self.deleteAllData(entity: "Lessons")
            guard let appDelegate2 = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext2 = appDelegate2.persistentContainer.viewContext
            let query2 = CKQuery(recordType: "Lessons", predicate: NSPredicate(value: true))
            database2.perform(query2, inZoneWith: nil) { (records, _) in
                var lessons = [CKRecord]()
                guard let records = records else{return}
                lessons = records
                var counter = lessons.count
                while counter > 0{
                    let entity2 = NSEntityDescription.entity(forEntityName: "Lessons",
                                                             in: managedContext2)!
                    let person = NSManagedObject(entity: entity2, insertInto: managedContext2)
                    person.setValue(String(lessons[counter - 1].recordID.recordName), forKeyPath: "recordID")
                    person.setValue(lessons[counter - 1].value(forKey: "dayOfWeek") as! String, forKeyPath: "dayOfWeek")
                    person.setValue(lessons[counter - 1].value(forKey: "endTime") as! String, forKeyPath: "endTime")
                    person.setValue(lessons[counter - 1].value(forKey: "startTime") as! String, forKeyPath: "startTime")
                    person.setValue(lessons[counter - 1].value(forKey: "period") as! String, forKeyPath: "period")
                    person.setValue(lessons[counter - 1].value(forKey: "teacherName") as! String, forKeyPath: "teacherName")
                    person.setValue(lessons[counter - 1].value(forKey: "weekNumber") as! String, forKeyPath: "weekNumber")
                    do {
                        try managedContext.save()
                        counter = counter - 1
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
                
            }
            
            let database3 = CKContainer.default().privateCloudDatabase
            self.deleteAllData(entity: "Teachers")
            guard let appDelegate3 = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext3 = appDelegate3.persistentContainer.viewContext
            let query3 = CKQuery(recordType: "Teachers", predicate: NSPredicate(value: true))
            database3.perform(query3, inZoneWith: nil) { (records, _) in
                var lessons = [CKRecord]()
                guard let records = records else{return}
                lessons = records
                var counter = lessons.count
                
                while counter > 0{
                    let entity3 = NSEntityDescription.entity(forEntityName: "Teachers",
                                                             in: managedContext3)!
                    let person = NSManagedObject(entity: entity3,
                                                 insertInto: managedContext3)
                    
                    
                    person.setValue(lessons[counter - 1].value(forKey: "teacherIconName") as! String, forKeyPath: "teacherIconName")
                    person.setValue(lessons[counter - 1].value(forKey: "teacherSubject") as! String, forKeyPath: "teacherSubject")
                    person.setValue(lessons[counter - 1].value(forKey: "teacherName") as! String, forKeyPath: "teacherName")
                    person.setValue(lessons[counter - 1].value(forKey: "teacherRoom") as! String, forKeyPath: "teacherRoom")
                    do {
                        try managedContext.save()
                        counter = counter - 1
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.performSegue(withIdentifier: "splashRestore", sender: nil)
                print("done")
            })
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
