//
//  ViewControllerAddPeriods.swift
//  GarmanApps
//
//  Created by Ben Garman on 16/06/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit
import iOSDropDown
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
class Period {
    var weekNumber : Int
    var day : String
    var period : Int
    var teacher : String
    var startTime : String
    var endTime : String
    
    init(xWeekNumber : Int, xDay: String, xPeriod : Int, xTeacher : String , xStartTime : String, xEndTime : String ) {
        self.weekNumber = xWeekNumber
        self.day = xDay
        self.period = xPeriod
        self.teacher = xTeacher
        self.startTime = xStartTime
        self.endTime = xEndTime
    }
}
class ViewControllerAddPeriods: UIViewController{

    
    var periods:[Period] = []
    private var datePicker: UIDatePicker?
    private var datePicker2: UIDatePicker?

    var week = 1
    @IBOutlet weak var periodName: UILabel!
    @IBOutlet weak var dayOfWeekSelector: UIImageView!
    @IBOutlet weak var weekOutput: UILabel!
    @IBOutlet weak var teacherDropDown: DropDown!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var Period1: UIButton!
    @IBOutlet weak var Period2: UIButton!
    @IBOutlet weak var Period3: UIButton!
    @IBOutlet weak var Period4: UIButton!
    @IBOutlet weak var Period5: UIButton!
    @IBOutlet weak var Period6: UIButton!
    @IBOutlet weak var Period7: UIButton!
    @IBOutlet weak var Period8: UIButton!
    
    @IBAction func addPeriodClicked(_ sender: Any) {
        if periodName.text != "Select A Period"{
            if teacherDropDown.text != ""{
                if startTimeTextField.text != ""{
                    if endTimeTextField.text != ""{
                        let tee = periodName.text?.deletingPrefix("Period ")
                        let period = Period(xWeekNumber: week, xDay: (dayOfWeekSelector.restorationIdentifier?.deletingSuffix("1"))!, xPeriod: Int(tee!)!, xTeacher: teacherDropDown.text!, xStartTime: startTimeTextField.text!, xEndTime: endTimeTextField.text!)
                        periods.append(period)
                        periodName.text = "Select A Period"
                        teacherDropDown.text = ""
                        startTimeTextField.text = ""
                        endTimeTextField.text = ""
                        if Int(tee!) == 1{
                            Period1.setImage(UIImage(named: "Period1Done"), for: .normal)
                        } else if Int(tee!) == 2{
                            Period2.setImage(UIImage(named: "Period2Done"), for: .normal)
                        } else if Int(tee!) == 3{
                            Period3.setImage(UIImage(named: "Period3Done"), for: .normal)
                        } else if Int(tee!) == 4{
                            Period4.setImage(UIImage(named: "Period4Done"), for: .normal)
                        } else if Int(tee!) == 5{
                            Period5.setImage(UIImage(named: "Period5Done"), for: .normal)
                        } else if Int(tee!) == 6{
                            Period6.setImage(UIImage(named: "Period6Done"), for: .normal)
                        } else if Int(tee!) == 7{
                            Period7.setImage(UIImage(named: "Period7Done"), for: .normal)
                        } else if Int(tee!) == 8{
                            Period8.setImage(UIImage(named: "Period8Done"), for: .normal)
                        }
                    }else{
                        let alert = UIAlertController(title: "End Time", message: "Please enter the time the lesson ends at.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: "Start Time", message: "Please enter the time the lesson starts at.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Teacher", message: "Please enter the teachers name for the lesson.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Select Period", message: "Please select a period and try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func backClicked(_ sender: Any) {
        GlobalVariables.periods = periods
        self.performSegue(withIdentifier: "backback", sender: nil)
    }
    @IBAction func leftArrowClicked(_ sender: Any) {
        if weekOutput.text == "Week 2"{
            UIView.transition(with: weekOutput as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.weekOutput.text = "Week 1"
                self.week = 1
                self.changeWeek()
            }, completion: nil)
        }
    }
    @IBAction func rightArrowClicked(_ sender: Any) {
        if weekOutput.text == "Week 1"{
            UIView.transition(with: weekOutput as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.weekOutput.text = "Week 2"
                self.week = 2
                self.changeWeek()
            }, completion: nil)
        }
    }
    func changeWeek(){
        UIView.transition(with: dayOfWeekSelector as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            self.Period1.setImage(UIImage(named: "Period1"), for: .normal)
            self.Period2.setImage(UIImage(named: "Period2"), for: .normal)
            self.Period3.setImage(UIImage(named: "Period3"), for: .normal)
            self.Period4.setImage(UIImage(named: "Period4"), for: .normal)
            self.Period5.setImage(UIImage(named: "Period5"), for: .normal)
            self.Period6.setImage(UIImage(named: "Period6"), for: .normal)
            self.Period7.setImage(UIImage(named: "Period7"), for: .normal)
            self.Period8.setImage(UIImage(named: "Period8"), for: .normal)
            self.periodName.text = "Select A Period"
            self.teacherDropDown.text = ""
            self.startTimeTextField.text = ""
            self.endTimeTextField.text = ""
            for x in self.periods{
                if x.day == (self.dayOfWeekSelector.restorationIdentifier?.deletingSuffix("1"))! && x.weekNumber == self.week{
                    if x.period == 1{
                        self.Period1.setImage(UIImage(named: "Period1Done"), for: .normal)
                    }else if x.period == 2{
                        self.Period2.setImage(UIImage(named: "Period2Done"), for: .normal)
                    }else if x.period == 3{
                        self.Period3.setImage(UIImage(named: "Period3Done"), for: .normal)
                    }else if x.period == 4{
                        self.Period4.setImage(UIImage(named: "Period4Done"), for: .normal)
                    }else if x.period == 5{
                        self.Period5.setImage(UIImage(named: "Period5Done"), for: .normal)
                    }else if x.period == 6{
                        self.Period6.setImage(UIImage(named: "Period6Done"), for: .normal)
                    }else if x.period == 7{
                        self.Period7.setImage(UIImage(named: "Period7Done"), for: .normal)
                    }else if x.period == 8{
                        self.Period8.setImage(UIImage(named: "Period8Done"), for: .normal)
                    }
                    
                }
            }
        }, completion: nil)
        
    }
    
    @IBAction func dayClicked(_ sender: UIButton) {
        let text = sender.restorationIdentifier!
        UIView.transition(with: dayOfWeekSelector as UIView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.dayOfWeekSelector.image = UIImage(named: "weekDayPeriod" + text)
            self.dayOfWeekSelector.restorationIdentifier = text + "1"
            self.Period1.setImage(UIImage(named: "Period1"), for: .normal)
            self.Period2.setImage(UIImage(named: "Period2"), for: .normal)
            self.Period3.setImage(UIImage(named: "Period3"), for: .normal)
            self.Period4.setImage(UIImage(named: "Period4"), for: .normal)
            self.Period5.setImage(UIImage(named: "Period5"), for: .normal)
            self.Period6.setImage(UIImage(named: "Period6"), for: .normal)
            self.Period7.setImage(UIImage(named: "Period7"), for: .normal)
            self.Period8.setImage(UIImage(named: "Period8"), for: .normal)
            self.periodName.text = "Select A Period"
            self.teacherDropDown.text = ""
            self.startTimeTextField.text = ""
            self.endTimeTextField.text = ""
            for x in self.periods{
                if x.day == (self.dayOfWeekSelector.restorationIdentifier?.deletingSuffix("1"))! && x.weekNumber == self.week{
                    if x.period == 1{
                        self.Period1.setImage(UIImage(named: "Period1Done"), for: .normal)
                    }else if x.period == 2{
                        self.Period2.setImage(UIImage(named: "Period2Done"), for: .normal)
                    }else if x.period == 3{
                        self.Period3.setImage(UIImage(named: "Period3Done"), for: .normal)
                    }else if x.period == 4{
                        self.Period4.setImage(UIImage(named: "Period4Done"), for: .normal)
                    }else if x.period == 5{
                        self.Period5.setImage(UIImage(named: "Period5Done"), for: .normal)
                    }else if x.period == 6{
                        self.Period6.setImage(UIImage(named: "Period6Done"), for: .normal)
                    }else if x.period == 7{
                        self.Period7.setImage(UIImage(named: "Period7Done"), for: .normal)
                    }else if x.period == 8{
                        self.Period8.setImage(UIImage(named: "Period8Done"), for: .normal)
                    }
                    
                }
            }
        }, completion: nil)
    }
    @IBAction func period1Clicked(_ sender: UIButton) {
        
        
        let text = sender.restorationIdentifier!
        var text2 = sender.restorationIdentifier!
        text2.insert(" ", at: text.index(text.startIndex, offsetBy: 6))
        
        UIView.transition(with: sender as UIView, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.periodName.text = text2
            
            if self.Period1.imageView!.image == UIImage(named: "Period1Selected"){
                self.Period1.setImage(UIImage(named: "Period1"), for: .normal)
            }
            if self.Period2.imageView!.image == UIImage(named: "Period2Selected"){
                self.Period2.setImage(UIImage(named: "Period2"), for: .normal)
            }
            if self.Period3.imageView!.image == UIImage(named: "Period3Selected"){
                self.Period3.setImage(UIImage(named: "Period3"), for: .normal)
            }
            if self.Period4.imageView!.image == UIImage(named: "Period4Selected"){
                self.Period4.setImage(UIImage(named: "Period4"), for: .normal)
            }
            if self.Period5.imageView!.image == UIImage(named: "Period5Selected"){
                self.Period5.setImage(UIImage(named: "Period5"), for: .normal)
            }
            if self.Period6.imageView!.image == UIImage(named: "Period6Selected"){
                self.Period6.setImage(UIImage(named: "Period6"), for: .normal)
            }
            if self.Period7.imageView!.image == UIImage(named: "Period7Selected"){
                self.Period7.setImage(UIImage(named: "Period7"), for: .normal)
            }
            if self.Period8.imageView!.image == UIImage(named: "Period8Selected"){
                self.Period8.setImage(UIImage(named: "Period8"), for: .normal)
            }
            if sender.imageView?.image == UIImage(named: text){
                
                
                sender.setImage(UIImage(named: text + "Selected"), for: .normal)
                
                self.teacherDropDown.text = ""
                self.startTimeTextField.text = ""
                self.endTimeTextField.text = ""
                self.teacherDropDown.isEnabled = true
                self.startTimeTextField.isEnabled = true
                self.endTimeTextField.isEnabled = true
                
            }else if sender.imageView?.image == UIImage(named: text + "Done"){
                
                for x in self.periods{
                    if x.day == (self.dayOfWeekSelector.restorationIdentifier?.deletingSuffix("1"))! && x.period == Int((self.periodName.text?.deletingPrefix("Period "))!) && x.weekNumber == self.week{
                        self.teacherDropDown.text = x.teacher
                        self.startTimeTextField.text = x.startTime
                        self.endTimeTextField.text = x.endTime
                        self.teacherDropDown.isEnabled = false
                        self.startTimeTextField.isEnabled = false
                        self.endTimeTextField.isEnabled = false
                    }
                }
            }
        }, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 100
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += 100
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        periods = GlobalVariables.periods
        changeWeek()
        GlobalVariables.periods = []
        teacherDropDown.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: teacherDropDown.frame.height))
        teacherDropDown.leftViewMode = .always
        startTimeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: startTimeTextField.frame.height))
        startTimeTextField.leftViewMode = .always
        endTimeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: endTimeTextField.frame.height))
        endTimeTextField.leftViewMode = .always
        var tempArray :[String] = []
        for temp in GlobalVariables.teachers{
            tempArray.append(temp)
        }
        teacherDropDown.optionArray = tempArray
        self.hideKeyboardWhenTappedAround()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.minuteInterval = 5
        datePicker?.addTarget(self, action: #selector(ViewControllerAddPeriods.dateChanged(datePicker:)), for: .valueChanged)
        
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .time
        datePicker2?.minuteInterval = 5
        datePicker2?.addTarget(self, action: #selector(ViewControllerAddPeriods.dateChanged2(datePicker:)), for: .valueChanged)
        startTimeTextField.inputView = datePicker
        endTimeTextField.inputView = datePicker2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func doneClicked(_ sender: Any) {
        if periods.count != 0 {
            GlobalVariables.periods = periods
            self.performSegue(withIdentifier: "upload", sender: nil)
        }else{
            let alert = UIAlertController(title: "Input Periods", message: "Please enter at least one period to continue.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        startTimeTextField.text = dateFormatter.string(from: datePicker.date)
    }
    @objc func dateChanged2(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        endTimeTextField.text = dateFormatter.string(from: datePicker.date)
    }

}
