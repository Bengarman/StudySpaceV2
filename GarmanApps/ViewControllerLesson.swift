//
//  ViewControllerLesson.swift
//  GarmanApps
//
//  Created by Ben Garman on 12/02/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerLesson: UIViewController,UITableViewDataSource,UITableViewDelegate {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var currentWeek = 1
    var rotationCounter = 0
    var count = 9
    @IBOutlet weak var dayOutput: UILabel!
    @IBOutlet weak var weekOutput: UILabel!
    
    @IBOutlet weak var pictureChnager: UIImageView!
    @IBOutlet weak var dropDown: UIButton!
    @IBOutlet weak var weekViewer: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var day = "Monday"

    @IBAction func buttonPressed(_ sender: UIButton) {
        pictureChnager.image = UIImage(named: sender.restorationIdentifier! + "daySelected")
        day = sender.restorationIdentifier! + "day"
        dayOutput.text = sender.restorationIdentifier! + "day"
        
        self.research()
        
    }
    func research(){
        people = []
        let managedContext = GlobalVariables.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lessons")
        let predicate1:NSPredicate = NSPredicate(format: "dayOfWeek = '" + self.day + "'")
        let predicate2:NSPredicate = NSPredicate(format: "weekNumber = '" + String(self.currentWeek) + "'")
        let predicate:NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2] )
        fetchRequest.predicate = predicate
        
        let sort = NSSortDescriptor(key: #keyPath(Lessons.startTimeDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.returnsObjectsAsFaults = false
        do {
            people = try managedContext.fetch(fetchRequest)
            print(people.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.contentOffset = .zero
        tableView.reloadData()
        
    }
    
    @IBAction func dropDownButton(_ sender: Any) {
        if rotationCounter == 0{
            UIView.animate(withDuration: 0.5) {
                self.tableView.frame = CGRect(x: 0, y: 322, width: 375, height: 387)
                self.dropDown.imageView?.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                self.rotationCounter = 1
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.tableView.frame = CGRect(x: 0, y: 195, width: 375, height: 514)
                self.dropDown.imageView?.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                self.rotationCounter = 0
            }}}
   
    @IBAction func rightButtonPressed(_ sender: Any) {
        if currentWeek == 1{
            UIView.animate(withDuration: 0.5) {
                self.weekViewer.text = "Week 2"
                self.weekOutput.text = "Week 2"
            }
            currentWeek = 2
            self.research()
        }}
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        if currentWeek == 2{
            UIView.animate(withDuration: 0.5) {
                self.weekViewer.text = "Week 1"
                self.weekOutput.text = "Week 1"
            }
            currentWeek = 1
            self.research()
        }}
    var people: [NSManagedObject] = []
    var teacher:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let managedContext = GlobalVariables.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lessons")
        let predicate1:NSPredicate = NSPredicate(format: "dayOfWeek = '" + self.day + "'")
        let predicate2:NSPredicate = NSPredicate(format: "weekNumber = '" + String(self.currentWeek) + "'")
        let predicate:NSPredicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2] )
        fetchRequest.predicate = predicate
        
        let sort = NSSortDescriptor(key: #keyPath(Lessons.startTimeDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            people = try managedContext.fetch(fetchRequest)
            print(people.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Teachers")
        do {
            teacher = try managedContext.fetch(fetchRequest2)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return people.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == people.count{
            return 0
        }else{
            return 1
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "lessons", for: indexPath) as! TableViewCellTimeTable
        let person = people[indexPath.section]
        for teach in teacher{
            print(teach.value(forKeyPath: "teacherName") as? String)
            print(person.value(forKeyPath: "teacherName") as? String)
            print("")
            if teach.value(forKeyPath: "teacherName") as? String == person.value(forKeyPath: "teacherName") as? String{
                cell.lessonName.text = teach.value(forKeyPath: "teacherSubject") as? String
                cell.icons.image = GlobalVariables.image[Int((teach.value(forKeyPath: "teacherIconName") as? String)!)!]
                
            }
        }
        cell.lessonTeacher.text = person.value(forKeyPath: "teacherName") as? String
        cell.time.text = (person.value(forKeyPath: "startTime") as? String)!.dropLast(2) + " - " + (person.value(forKeyPath: "endTime") as? String)!.dropLast(2)

        return cell
    }
}
