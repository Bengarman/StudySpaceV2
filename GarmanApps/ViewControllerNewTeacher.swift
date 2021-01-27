//
//  ViewControllerNewTeacher.swift
//  GarmanApps
//
//  Created by Ben Garman on 10/05/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

class ViewControllerNewTeacher: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    let images = ["2", "3", "4", "5", "6", "7", "8", "9", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48","49", "50"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return GlobalVariables.image.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath as IndexPath) as! CollectionViewCell
        cell.imageViewer.image = GlobalVariables.image[indexPath.row]
        return cell
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if (actualPosition.x > 0){
                if pageController.currentPage == 2{
                    pageController.currentPage = 1
                }else if pageController.currentPage == 1{
                    pageController.currentPage = 0
                }
            }else{
                if pageController.currentPage == 0{
                    pageController.currentPage = 1
                }else if pageController.currentPage == 1{
                    pageController.currentPage = 2
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if teachers.count == 0{
            return 1
        }else{
            return teachers.count
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var roomTextField: UITextField!
    var teachers: [String] = []
    var images1 : [UIImage] = []
    var icons: [UIImage] = []
    var subjects: [String] = []
    var iconCode: [String] = []
    var rooms: [String] = []
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teachers", for: indexPath) as! TableViewCellTeachers
        if  teachers.count == 0{
            cell.teacherName.text = "Example Subject"
            cell.teacherName.textColor = UIColor.gray
            cell.subjectName.text = "Example Teacher"
            cell.subjectName.textColor = UIColor.gray
            cell.icon.image = UIImage(named: "15.png")
            cell.icon.contentMode = UIView.ContentMode.scaleToFill
        }else{
            cell.teacherName.text = rooms[indexPath.row] + " - " + teachers[indexPath.row]
            cell.subjectName.text = subjects[indexPath.row]
            cell.icon.image = icons[indexPath.row]
            cell.teacherName.textColor = UIColor.black
            cell.subjectName.textColor = UIColor.black
            cell.icon.contentMode = UIView.ContentMode.scaleAspectFit
        }
        
        return cell
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 250
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += 250
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        teachers.append(nameTextField.text!)
        rooms.append(roomTextField.text!)
        subjects.append(subjectTextField.text!)
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        icons.append(cell.imageViewer.image!)
        iconCode.append(String(indexPath.row))
        tableView.reloadData()
        nameTextField.text = ""
        subjectTextField.text = ""
        roomTextField.text = ""
        pageController.isHidden = true
        pageController.isEnabled = false
        addButton.setTitle("Next", for: .normal)
        collectionView.isHidden = true
        collectionView.isUserInteractionEnabled = false
    }
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addTeacherPressed(_ sender: Any) {
        if addButton.currentTitle == "Next"{
            pageController.isHidden = false
            pageController.isEnabled = true
            collectionView.isHidden = false
            collectionView.isUserInteractionEnabled = true
            addButton.setTitle("Select Icon", for: .normal)
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        if GlobalVariables.done == true{
            teachers = GlobalVariables.teachers
            images1 = GlobalVariables.images1
            icons = GlobalVariables.icons
            subjects = GlobalVariables.subjects
            rooms = GlobalVariables.rooms
            iconCode = GlobalVariables.iconCode
            GlobalVariables.teachers = []
            GlobalVariables.images1 = []
            GlobalVariables.icons = []
            GlobalVariables.subjects = []
            GlobalVariables.rooms = []
            GlobalVariables.iconCode = []
            tableView.reloadData()
        }
        
        
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: nameTextField.frame.height))
        
        nameTextField.leftViewMode = .always
        subjectTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: subjectTextField.frame.height))
        subjectTextField.leftViewMode = .always
        roomTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: roomTextField.frame.height))
        roomTextField.leftViewMode = .always
        collectionView.reloadData()
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func finishAddingClicked(_ sender: Any) {
        if teachers.count != 0 {
            GlobalVariables.teachers = teachers
            GlobalVariables.images1 = images1
            GlobalVariables.icons = icons
            GlobalVariables.subjects = subjects
            GlobalVariables.rooms = rooms
            GlobalVariables.iconCode = iconCode
            GlobalVariables.done = true
            self.performSegue(withIdentifier: "gogogo", sender: nil)
        }else{
            let alert = UIAlertController(title: "Input Teacher", message: "Please enter at least one teacher to continue.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
