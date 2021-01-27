//Splash Screen

import UIKit
import CoreData
import CloudKit
import AVFoundation

struct GlobalVariables {
    static var teachers: [String] = []
    static var images1 : [UIImage] = []
    static var icons: [UIImage] = []
    static var subjects: [String] = []
    static var rooms: [String] = []
    static var image : [UIImage] = []
    static var iconCode: [String] = []
    static var periods:[Period] = []
    static var done = false
    static var reload = false
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let managedContext = GlobalVariables.appDelegate.persistentContainer.viewContext
}

class SplashScreenViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    let images = ["2", "3", "4", "5", "6", "7", "8", "9", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48","49", "50"]
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    @IBOutlet weak var videoView: UIView!
    var biggerThanOne = true
    
   

    override func viewDidLoad() {
        
        guard let path = Bundle.main.path(forResource: "Final", ofType:"mp4") else {
            debugPrint("Final.mp4 not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(SplashScreenViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        videoView.layer.addSublayer(avPlayerLayer)
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        player.play()
        for item in images{
            GlobalVariables.image.append(UIImage(named: item)!)
        }
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            checkLessons()
            
        }else{
            print("Internet Connection not Available!")
            checkLessons()
            
        }
        
        super.viewDidLoad()
    }
    func checkLessons(){
        let managedContext = GlobalVariables.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Lessons")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            if results.count == 0{
                self.biggerThanOne = false
            }
        } catch let error as NSError {
            print("boohoo")
        }
    }
    
    
    @objc func finishVideo()
    {
        if biggerThanOne == true{
            self.performSegue(withIdentifier: "go", sender: nil)

        }else{
            self.performSegue(withIdentifier: "newbie", sender: nil)

        }
    }

    override func viewDidLayoutSubviews() {
        avPlayerLayer.frame = videoView.layer.bounds
    }
    
    

}


extension UIViewController{
    
    func deleteAllData(entity: String)
    {
        let managedContext = GlobalVariables.managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
        
    }
    
    func saveToCore(){
        /*
        let database = CKContainer.default().privateCloudDatabase
        self.deleteAllData(entity: "Teachers")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let query = CKQuery(recordType: "Teachers", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, _) in
            var notes = [CKRecord]()
            guard let records = records else{return}
            notes = records
            var counter = notes.count
            while counter > 0{
                let entity = NSEntityDescription.entity(forEntityName: "Teachers",
                                                        in: managedContext)!
                let newPeriod = NSManagedObject(entity: entity, insertInto: managedContext)
                newPeriod.setValue(notes[counter - 1].value(forKey: "teacherIconName") as! String, forKey:"teacherIconName" )
                newPeriod.setValue(notes[counter - 1].value(forKey: "teacherSubject") as! String, forKey:"teacherSubject" )
                newPeriod.setValue(notes[counter - 1].value(forKey: "teacherName") as! String, forKey:"teacherName" )
                newPeriod.setValue(notes[counter - 1].value(forKey: "teacherRoom") as! String, forKey:"teacherRoom" )
                do {
                    try managedContext.save()
                    counter = counter - 1
                    print("saved")
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            print("should i be here")

        }
        
        */
        
        
    }
}


