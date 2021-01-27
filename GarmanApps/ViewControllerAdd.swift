import UIKit
import CloudKit
import CoreData

class ViewControllerAdd: UIViewController, SambagDatePickerViewControllerDelegate, SambagMonthYearPickerViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    let database = CKContainer.default().privateCloudDatabase
    var selector = 0
    var segmentIndex = 0
    var imageData = Data()
    var theme: SambagTheme = .light

    @IBOutlet weak var tabBarAdd: UITabBarItem!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var urgencyPressed: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateTextResult: UILabel!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var segementImage: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var Subjectbutton: UIButton!
    @IBOutlet weak var clickToAddDate: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addPicture: UIButton!
    
    @IBAction func addPictureButton(_ sender: Any) {
        pageReloader = 1
        if addPicture.titleLabel?.text == "Add Photo"{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }else{
            imageData.removeAll()
            addPicture.setTitle("Add Photo", for: .normal)
        }
    }
    
    var medialUR = NSURL()
    var imagestuff = Data()

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        imagestuff = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage).jpegData(compressionQuality: 0.5)!
        /*let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let image = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage)
        let filePath = "\(paths[0])/MyImageName.jpg"
        do{
            try image.jpegData(compressionQuality: 0.5)?.write(to: URL(fileURLWithPath: filePath), options: NSData.WritingOptions.atomicWrite)
        }catch{
            print("error")
        }
        
        let localFile = NSURL(fileURLWithPath: filePath)
        medialUR = localFile*/
        addPicture.setTitle("Remove Photo", for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func resetPage() {
        DispatchQueue.main.async {
            let managedContext = GlobalVariables.managedContext
            let entity = NSEntityDescription.entity(forEntityName: "Homework", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(self.urgencyLabel.text, forKeyPath: "urgency")
            var dateComponents = DateComponents()
            
            let temp = self.dateTextResult.text!
            var x = (temp.dropLast(2)).dropFirst(5)
            if temp.count == 10{
                dateComponents.year = Int(temp.dropLast(6))!
                x = (temp.dropLast(2)).dropFirst(5)
                dateComponents.day = Int(temp.dropFirst(9))
                dateComponents.timeZone = TimeZone(abbreviation: "UTC")
            }else{
                dateComponents.year = Int(temp.dropLast(7))!
                x = (temp.dropLast(3)).dropFirst(5)
                dateComponents.day = Int(temp.dropFirst(9))
                dateComponents.timeZone = TimeZone(abbreviation: "UTC")
            }
            
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
            
            let userCalendar = Calendar.current
            let someDateTime = userCalendar.date(from: dateComponents)
            
            person.setValue(someDateTime, forKeyPath: "accDate")
            person.setValue(self.creation, forKeyPath: "creationDate")
            person.setValue(self.dateTextResult.text!, forKeyPath: "date")
            person.setValue(self.recordid, forKeyPath: "recordID")
            person.setValue(self.titleTextView.text!, forKeyPath: "task")
            person.setValue(self.subjectLabel.text!, forKeyPath: "subject")
            person.setValue(self.descriptionTextView.text!, forKeyPath: "description1")
            do {
                try managedContext.save()
                print("saved")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            self.urgencyLabel.text = ""
            self.descriptionTextView.text = ""
            self.dateTextResult.text = ""
            self.subjectLabel.text = ""
            self.titleTextView.text = ""
            self.Subjectbutton.imageView?.image = UIImage(named: "subjectField")
            self.clickToAddDate.imageView?.image = UIImage(named: "dateHW")
            self.urgencyPressed.imageView?.image = UIImage(named: "urgency1")
            
            let alert = UIAlertController(title: "Homework Added", message: "Homework entry has been added succesfully.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
            
        }
    }
    
    func resetPageNotes() {
        
        DispatchQueue.main.async {
            let managedContext = GlobalVariables.managedContext
            let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(self.imagestuff, forKeyPath: "picture")
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
            }
            
            self.urgencyLabel.text = ""
            self.descriptionTextView.text = ""
            self.dateTextResult.text = ""
            self.subjectLabel.text = ""
            self.titleTextView.text = ""
            //self.Subjectbutton.imageView?.image = UIImage(named: "subjectField")
            //self.clickToAddDate.imageView?.image = UIImage(named: "dateHW")
            //self.urgencyPressed.imageView?.image = UIImage(named: "urgency1")
            
            let alert = UIAlertController(title: "Homework Added", message: "Homework entry has been added succesfully.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
        }
        
        
        
        
        
        
    }
    
    var recordid = ""
    var creation = Date()
    var pageReloader = 0
    @IBAction func savePressed(_ sender: Any) {
        if selector == 0{
            let newNote = CKRecord(recordType: "Homework")
            if urgencyLabel.text == "" || dateTextResult.text == "" || subjectLabel.text == "" || titleTextView.text == ""{
                let alert = UIAlertController(title: "Enter Data", message: "Please ensure all data is entered correctly.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert,animated: true,completion: nil)
                

            }else{
                newNote.setValue(urgencyLabel.text!, forKey:"urgency" )
                newNote.setValue(descriptionTextView.text!, forKey: "description")
                newNote.setValue(dateTextResult.text!, forKey: "date")
                newNote.setValue(subjectLabel.text!, forKey: "subject")
                newNote.setValue(titleTextView.text!, forKey: "task")
                database.save(newNote) { (record,error) in
                    
                    if error == nil{
                        
                        self.recordid = (record?.recordID.recordName)!
                        self.creation = ((record?.creationDate!)!)
                        
                        self.resetPage()
                        //self.saveToCore()
                    }else {
                        let alert = UIAlertController(title: "Error", message: "Please check internet connection and ensure you are signed into iCloud.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert,animated: true,completion: nil)
                    }
                }
            }
            
        }else{
            let newNote = CKRecord(recordType: "Notes")
            if dateTextResult.text == "" || subjectLabel.text == "" || titleTextView.text == ""{
                let alert = UIAlertController(title: "Enter Data", message: "Please ensure all data is entered correctly.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert,animated: true,completion: nil)
                
                
            }else{
                //let test = CKAsset(fileURL: medialUR as URL)
                newNote.setValue(descriptionTextView.text!, forKey: "description")
                newNote.setValue(dateTextResult.text!, forKey: "date")
                newNote.setValue(subjectLabel.text!, forKey: "subject")
                newNote.setValue(titleTextView.text!, forKey: "title")
                newNote["pic"] = imagestuff
                database.save(newNote) { (record,error) in
                    
                    if error == nil{
                        print("saved to cloud")
                        self.recordid = (record?.recordID.recordName)!
                        self.creation = ((record?.creationDate!)!)
                        self.resetPageNotes()
                    }else {
                        let alert = UIAlertController(title: "Error", message: "Please check internet connection and ensure you are signed into iCloud.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.present(alert,animated: true,completion: nil)
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func urgencyPressedActual(_ sender: Any) {
        selector = 0
        let vc = SambagMonthYearPickerViewController()
        vc.theme = theme
        vc.subjects.append("Very Low")
        vc.subjects.append("Low")
        vc.subjects.append("Default")
        vc.subjects.append("High")
        vc.subjects.append("Very High")
        vc.delegate = self as SambagMonthYearPickerViewControllerDelegate
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func hwTabBtnPressed(_ sender: Any) {
        segementImage.image = UIImage(named: "HWSelected")
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.backgroundImage.image = UIImage(named: "hwPath")
            self.descriptionTextView.frame = CGRect(x: 55, y: 351, width: 276, height: 81)
            self.clickToAddDate.frame = CGRect(x: 55, y: 480, width: 276, height: 39)
            self.dateTextResult.frame = CGRect(x: 76, y: 492, width: 217, height: 15)
            self.urgencyPressed.frame = CGRect(x: 55, y: 572, width: 276, height: 39)
            self.urgencyLabel.frame = CGRect(x: 76, y: 584, width: 217, height: 15)
            self.urgencyPressed.isHidden = false
            self.urgencyLabel.isHidden = false
            self.addPicture.isHidden = true
        })
        segmentIndex = 0
    }
    
    @IBAction func dateClicked(_ sender: Any) {
       let vc = SambagDatePickerViewController()
        vc.theme = theme
        vc.delegate = self as SambagDatePickerViewControllerDelegate
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func notesTabBtnPressed(_ sender: Any) {
        segementImage.image = UIImage(named: "NotesSelected")
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.backgroundImage.image = UIImage(named: "notesPath")
            self.descriptionTextView.frame = CGRect(x: 55, y: 351, width: 276, height: 139)
            self.clickToAddDate.frame = CGRect(x: 55, y: 537, width: 276, height: 39)
            self.dateTextResult.frame = CGRect(x: 76, y: 549, width: 217, height: 15)
            self.urgencyPressed.frame = CGRect(x: 55, y: 537, width: 276, height: 39)
            self.urgencyLabel.frame = CGRect(x: 76, y: 549, width: 217, height: 15)
            self.urgencyPressed.isHidden = true
            self.urgencyLabel.isHidden = true
            self.addPicture.isHidden = false
        })
        segmentIndex = 1
    }
    
    @IBAction func clickToSelectSubjects(_ sender: Any) {
        selector = 1
        let vc = SambagMonthYearPickerViewController()
        vc.theme = theme
        vc.subjects.append("Business")
        vc.subjects.append("Computing")
        vc.subjects.append("Maths")
        vc.delegate = self as SambagMonthYearPickerViewControllerDelegate
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if pageReloader == 0{
            backgroundImage.alpha = 1
            urgencyLabel.alpha = 0
            urgencyPressed.alpha = 0
            descriptionTextView.alpha = 0
            dateTextResult.alpha = 0
            titleTextView.alpha = 0
            segementImage.alpha = 0
            subjectLabel.alpha = 0
            Subjectbutton.alpha = 0
            clickToAddDate.alpha = 0
            saveButton.alpha = 0
            addPicture.alpha = 0
            
            
            UIView.animate(withDuration: 1, animations: {
                self.urgencyLabel.alpha = 1
                self.urgencyPressed.alpha = 1
                self.descriptionTextView.alpha = 1
                self.dateTextResult.alpha = 1
                self.titleTextView.alpha = 1
                self.segementImage.alpha = 1
                self.subjectLabel.alpha = 1
                self.Subjectbutton.alpha = 1
                self.clickToAddDate.alpha = 1
                self.saveButton.alpha = 1
                self.addPicture.alpha = 1
                if self.segmentIndex == 0{
                    self.backgroundImage.image = UIImage(named: "hwPath")
                }else{
                    self.backgroundImage.image = UIImage(named: "notesPath")
                }
            })
        }else{
            pageReloader = 0
        }
        print(pageReloader)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if pageReloader == 0 {
            UIView.animate(withDuration: 1, animations: {
                self.urgencyLabel.alpha = 0
                self.urgencyPressed.alpha = 0
                self.descriptionTextView.alpha = 0
                self.dateTextResult.alpha = 0
                self.titleTextView.alpha = 0
                self.segementImage.alpha = 0
                self.backgroundImage.alpha = 0
                self.subjectLabel.alpha = 0
                self.Subjectbutton.alpha = 0
                self.clickToAddDate.alpha = 0
                self.saveButton.alpha = 0
                self.addPicture.alpha = 0
            })
        }
        
        
    }
    
    override func viewDidLoad() {
        urgencyLabel.alpha = 0
        urgencyPressed.alpha = 0
        descriptionTextView.alpha = 0
        dateTextResult.alpha = 0
        titleTextView.alpha = 0
        segementImage.alpha = 0
        subjectLabel.alpha = 0
        Subjectbutton.alpha = 0
        clickToAddDate.alpha = 0
        saveButton.alpha = 0
        addPicture.alpha = 0
        super.viewDidLoad()

        
        
        
        
        titleTextView.setLeftPaddingPoints(15.0)
        descriptionTextView.textContainerInset  = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 5);
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        dateTextResult.text = result.description
        clickToAddDate.setImage(UIImage(named: "dateHWNO"), for: UIControl.State.normal)
        viewController.dismiss(animated: true, completion: nil)
    }
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagMonthYearPickerDidSet(_ viewController: SambagMonthYearPickerViewController, result: SambagMonthYearPickerResult) {
        if selector == 1{
            subjectLabel.text = result.tot
            Subjectbutton.setImage(UIImage(named: "subjectFieldNone"), for: UIControl.State.normal)
        }else{
            urgencyLabel.text = result.tot
            urgencyPressed.setImage(UIImage(named: "urgency2"), for: UIControl.State.normal)
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    func sambagMonthYearPickerDidCancel(_ viewController: SambagMonthYearPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= 227
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += 227
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    
    
    
    
}
extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

