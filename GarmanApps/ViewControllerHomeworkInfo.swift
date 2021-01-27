//
//  ViewControllerHomeworkInfo.swift
//  FoldingCell
//
//  Created by Ben Garman on 06/07/2019.
//

import UIKit
import CoreData
import CloudKit

class ViewControllerHomeworkInfo: UIViewController {

    override func viewDidLoad() {
        subjectLbl.text = temp.teacher
        nameLbl.text = temp.taskName
        dateLbl.text = temp.dueDate
        urgencyLbl.text = temp.urgency
        descriptionLbl.text = temp.description
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var urgencyLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func completedBtnPressed(_ sender: Any) {
        let managedContext = GlobalVariables.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Homework")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let people = try managedContext.fetch(fetchRequest)
            for item in people{
                if item.objectID == temp.objectId{
                    print("this one")
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
        let myID = CKRecord.ID(recordName: temp.id)
        
        database.delete(withRecordID: myID) { (recordID, error) -> Void in
            guard let recordID = recordID else {
                print("Error deleting record: ")
                return
            }
            print("Successfully deleted record: ",
                  recordID.recordName)
        }
        
        self.dismiss(animated: true, completion: nil)
        
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
