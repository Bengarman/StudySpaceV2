import UIKit
import CoreData

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    let kHeaderSectionTag: Int = 6900;
    
    @IBOutlet weak var tableView: UITableView!
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionDates: Array<Any> = []
    var sectionNames: Array<Any> = []
    var sectionImage: Array<Any> = []
    var sectionSubject: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        research()
        /*
        sectionNames = [ "Mario", "Fiona", "Charlie" ];
        sectionSubject = [ "Maths", "Business", "Computing" ];
        sectionImage = [ GlobalVariables.image[24], GlobalVariables.image[11], GlobalVariables.image[1] ];
        sectionItems = [ ["iPhone 5", "iPhone 5s", "iPhone 6", "iPhone 6 Plus", "iPhone 7", "iPhone 7 Plus"],
                         ["iPad Mini", "iPad Air 2", "iPad Pro", "iPad Pro 9.7"],
                         ["Apple Watch", "Apple Watch 2", "Apple Watch 2 (Nike)"]
        ];*/
        self.tableView!.tableFooterView = UIView()
    }
    
    var teacher:[NSManagedObject] = []
    var people: [NSManagedObject] = []
    func research(){
        let managedContext = GlobalVariables.managedContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print(people.count)
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Teachers")
        do {
            teacher = try managedContext.fetch(fetchRequest2)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for x in teacher{
            var temp = [""]
            temp.removeAll()
            var temp2 = [""]
            temp2.removeAll()
            sectionNames.append(x.value(forKey: "teacherName") as! String)
            sectionSubject.append(x.value(forKey: "teacherSubject") as! String)
            sectionImage.append(GlobalVariables.image[Int(x.value(forKey: "teacherIconName") as! String)!])
            for z in people{
                if z.value(forKey: "subject") as! String == x.value(forKey: "teacherSubject") as! String{
                    temp.append(z.value(forKey: "title") as! String)
                    temp2.append(z.value(forKey: "date") as! String)
                }
            }
            sectionItems.append(temp)
            sectionDates.append(temp2)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myCustomView = UIView()
        myCustomView.frame = CGRect.init(x: 0, y: 50, width: 375, height: 128)
        myCustomView.addSubview(UIImageView.init(image:UIImage(named: "NotesScre")))
        let arrow = UIImageView()
        arrow.image = UIImage(named: "play-button")
        arrow.frame = CGRect.init(x: 312, y: 58, width: 12, height: 12)
        arrow.tag = kHeaderSectionTag + section
        myCustomView.addSubview(arrow)
        let category = UIImageView()
        category.image = sectionImage[section] as? UIImage
        category.frame = CGRect.init(x: 45, y: 32, width: 64, height: 64)
        category.contentMode = UIView.ContentMode.scaleToFill
        myCustomView.addSubview(category)
        let subject = UILabel()
        subject.frame = CGRect.init(x: 129, y: 42, width: 177, height: 21)
        subject.font = UIFont(name: "Montserrat-SemiBold", size: 16.0)
        subject.text = sectionNames[section] as? String
        myCustomView.addSubview(subject)
        let text = UILabel()
        text.frame = CGRect.init(x: 129, y: 69, width: 177, height: 18)
        text.font = UIFont(name: "Montserrat-Medium", size: 14.0)
        
        text.text = sectionSubject[section] as? String
        myCustomView.addSubview(text)
        
        myCustomView.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ViewController2.sectionHeaderWasTouched(_:)))
        myCustomView.addGestureRecognizer(headerTapGesture)
        
        return myCustomView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 128.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notes", for: indexPath) as! TableViewCellNotes
        let section = self.sectionItems[indexPath.section] as! NSArray
        let section2 = self.sectionDates[indexPath.section] as! NSArray
        cell.noteName?.text = section[indexPath.row] as? String
        //cell.textLabel?.textColor = UIColor.black
        cell.noteDate?.text = section2[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
   
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view
        let section    = headerView!.tag
        let eImageView = headerView!.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }

}
