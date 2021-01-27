//
//  ViewControllerLoading.swift
//  GarmanApps
//
//  Created by Ben Garman on 17/06/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

import CoreData
import CloudKit
class ViewControllerLoading: UIViewController {

    
    
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var textField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        videoView.loadGif(name: "loader")
        
        if GlobalVariables.reload == false{
            uploadToCloud()
            uploadToCore()
            queryDatabase()
        }else{
            queryDatabase2()
        }
    }
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let managedContext = appDelegate.persistentContainer.viewContext
    
    func queryDatabase2(){
        DispatchQueue.main.async {
            self.deleteAllData(entity: "Homework")
            self.deleteAllData(entity: "Lessons")
            self.deleteAllData(entity: "Teachers")
            self.deleteAllData(entity: "Notes")
        
            let database = CKContainer.default().privateCloudDatabase
            let managedContext = GlobalVariables.managedContext
        
            let query = CKQuery(recordType: "Homework", predicate: NSPredicate(value: true))
            database.perform(query, inZoneWith: nil) { (records, _) in
                var notes = [CKRecord]()
                guard let records = records else{return}
                notes = records
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
            print("homework done")
            managedContext.refreshAllObjects()
            let query2 = CKQuery(recordType: "Lessons", predicate: NSPredicate(value: true))
            database.perform(query2, inZoneWith: nil) { (records, _) in
                var lessons = [CKRecord]()
                guard let records = records else{return}
                lessons = records
                print("up to here")
                var counter = lessons.count
                print(counter)
                while counter > 0{
                    let entity2 = NSEntityDescription.entity(forEntityName: "Lessons",
                                                             in: managedContext)!
                    let person = NSManagedObject(entity: entity2, insertInto: managedContext)
                    //person.setValue(String(lessons[counter - 1].recordID.recordName), forKeyPath: "recordID")
                    person.setValue(lessons[counter - 1].value(forKey: "dayOfWeek") as! String, forKeyPath: "dayOfWeek")
                    person.setValue(lessons[counter - 1].value(forKey: "endTime") as! String, forKeyPath: "endTime")
                    person.setValue(lessons[counter - 1].value(forKey: "startTime") as! String, forKeyPath: "startTime")
                    person.setValue(lessons[counter - 1].value(forKey: "period") as! String, forKeyPath: "period")
                    person.setValue(lessons[counter - 1].value(forKey: "teacherName") as! String, forKeyPath: "teacherName")
                    person.setValue(lessons[counter - 1].value(forKey: "weekNumber") as! String, forKeyPath: "weekNumber")
                    let part = (lessons[counter - 1].value(forKey: "startTime") as! String)
                    var dateComponents = DateComponents()
                    dateComponents.year = 2000
                    dateComponents.month = 1
                    dateComponents.day = 1
                    dateComponents.timeZone = TimeZone(abbreviation: "UTC")
                    if part.dropFirst(6) == "pm"{
                        dateComponents.hour = Int(part.dropLast(6))! + 12
                    }else{
                        dateComponents.hour = Int(part.dropLast(6))!
                    }
                    dateComponents.minute = Int((part.dropLast(3)).dropFirst(3))!
                    
                    let userCalendar = Calendar.current
                    let someDateTime = userCalendar.date(from: dateComponents)
                    print(someDateTime)
                    person.setValue(someDateTime, forKeyPath: "startTimeDate")
                    
                    do {
                        try managedContext.save()
                        counter = counter - 1
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
                
            }
            managedContext.refreshAllObjects()
            let query3 = CKQuery(recordType: "Teachers", predicate: NSPredicate(value: true))
            database.perform(query3, inZoneWith: nil) { (records, _) in
                var lessons = [CKRecord]()
                guard let records = records else{return}
                lessons = records
                var counter = lessons.count
                
                while counter > 0{
                    let entity3 = NSEntityDescription.entity(forEntityName: "Teachers",
                                                             in: managedContext)!
                    let person = NSManagedObject(entity: entity3,
                                                 insertInto: managedContext)
                    
                    
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
            
            managedContext.refreshAllObjects()
            let query4 = CKQuery(recordType: "Notes", predicate: NSPredicate(value: true))
            database.perform(query4, inZoneWith: nil) { (records, _) in
                var notes = [CKRecord]()
                guard let records = records else{return}
                notes = records
                var counter = notes.count
                print(counter)
                while counter > 0{
                    let entity4 = NSEntityDescription.entity(forEntityName: "Notes",
                                                             in: managedContext)!
                    let person = NSManagedObject(entity: entity4,
                                                 insertInto: managedContext)
                    
                    person.setValue(notes[counter - 1].value(forKey: "date") as! String, forKeyPath: "date")
                    person.setValue(String(notes[counter - 1].recordID.recordName), forKeyPath: "recordID")
                    person.setValue(notes[counter - 1].value(forKey: "title") as! String, forKeyPath: "title")
                    person.setValue(notes[counter - 1].value(forKey: "subject") as! String, forKeyPath: "subject")
                    person.setValue(notes[counter - 1].value(forKey: "description") as! String, forKeyPath: "description1")
                    person.setValue(notes[counter - 1].value(forKey: "pic") as! Data, forKeyPath: "picture")
                    
                    do {
                        try managedContext.save()
                        counter = counter - 1
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
            }
            
            
            /*
 let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext)!
 let person = NSManagedObject(entity: entity, insertInto: managedContext)
 
 person.setValue(self.dateTextResult.text!, forKeyPath: "date")
 person.setValue(self.recordid, forKeyPath: "recordID")
 person.setValue(self.titleTextView.text!, forKeyPath: "title")
 person.setValue(self.subjectLabel.text!, forKeyPath: "subject")
 person.setValue(self.descriptionTextView.text!, forKeyPath: "description1")
 do {
 try managedContext.save()
 print("saved")
 } catch let error as NSError {
 print("Could not save. \(error), \(error.userInfo)")
 }*/
            
        
        }
        perform(#selector(authenticate), with: nil, afterDelay: 2)
    }
    
    
    @objc func authenticate(){
        self.performSegue(withIdentifier: "adderDone", sender: nil)
        print("done")
    }
    
    let database = CKContainer.default().privateCloudDatabase
    func queryDatabase(){
        DispatchQueue.main.async {
            let database = CKContainer.default().privateCloudDatabase
            self.deleteAllData(entity: "Homework")
            let managedContext = GlobalVariables.managedContext
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
            /*
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
            }*/
            
        }
        perform(#selector(authenticate), with: nil, afterDelay: 2)

        
    }
    func uploadToCloud(){
        for period in GlobalVariables.periods{
            let newPeriod = CKRecord(recordType: "Lessons")
            newPeriod.setValue(period.day, forKey:"dayOfWeek" )
            newPeriod.setValue(period.endTime, forKey:"endTime" )
            newPeriod.setValue(period.startTime, forKey:"startTime" )
            newPeriod.setValue(String(period.period), forKey:"period" )
            newPeriod.setValue(period.teacher, forKey:"teacherName" )
            newPeriod.setValue(String(period.weekNumber), forKey:"weekNumber" )
            database.save(newPeriod) { (record,error) in
                
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: "Please check internet connection and ensure you are signed into iCloud.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert,animated: true,completion: nil)
                }
            }
        }
        
        for n in 0...GlobalVariables.teachers.count - 1{
            print(GlobalVariables.teachers[n])
            
            let newPeriod = CKRecord(recordType: "Teachers")
            newPeriod.setValue(GlobalVariables.iconCode[n], forKey:"teacherIconName" )
            newPeriod.setValue(GlobalVariables.subjects[n], forKey:"teacherSubject" )
            newPeriod.setValue(GlobalVariables.teachers[n], forKey:"teacherName" )
            newPeriod.setValue(GlobalVariables.rooms[n], forKey:"teacherRoom" )
            database.save(newPeriod) { (record,error) in
                
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: "Please check internet connection and ensure you are signed into iCloud.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert,animated: true,completion: nil)
                }
            }
        }
    }
    
    func uploadToCore(){
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            for period in GlobalVariables.periods{
                let entity = NSEntityDescription.entity(forEntityName: "Lessons", in: managedContext)!
                let person = NSManagedObject(entity: entity, insertInto: managedContext)
                person.setValue(period.day, forKey:"dayOfWeek" )
                person.setValue(period.endTime, forKey:"endTime" )
                person.setValue(period.startTime, forKey:"startTime" )
                person.setValue(String(period.period), forKey:"period" )
                person.setValue(period.teacher, forKey:"teacherName" )
                person.setValue(String(period.weekNumber), forKey:"weekNumber" )
                
                
                var dateComponents = DateComponents()
                dateComponents.year = 2000
                dateComponents.month = 1
                dateComponents.day = 1
                dateComponents.timeZone = TimeZone(abbreviation: "UTC")
                if period.startTime.dropFirst(6) == "pm"{
                    dateComponents.hour = Int(period.startTime.dropLast(6))! + 12
                }else{
                    dateComponents.hour = Int(period.startTime.dropLast(6))!
                }
                dateComponents.minute = Int((period.startTime.dropLast(3)).dropFirst(3))!
                
                let userCalendar = Calendar.current
                let someDateTime = userCalendar.date(from: dateComponents)
                
                person.setValue(someDateTime, forKeyPath: "startTimeDate")
                
                do {
                    try managedContext.save()
                    print("saved")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
            for n in 0...GlobalVariables.teachers.count - 1{
                print(GlobalVariables.teachers[n])
                let entity = NSEntityDescription.entity(forEntityName: "Teachers", in: managedContext)!
                let newPeriod = NSManagedObject(entity: entity, insertInto: managedContext)
                newPeriod.setValue(GlobalVariables.iconCode[n], forKey:"teacherIconName" )
                newPeriod.setValue(GlobalVariables.subjects[n], forKey:"teacherSubject" )
                newPeriod.setValue(GlobalVariables.teachers[n], forKey:"teacherName" )
                newPeriod.setValue(GlobalVariables.rooms[n], forKey:"teacherRoom" )
                do {
                    try managedContext.save()
                    print("saved")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
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
