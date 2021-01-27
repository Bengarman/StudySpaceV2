//
//  ViewController.swift
//  tester
//
//  Created by Ben Garman on 29/05/2019.
//  Copyright © 2019 Ben Garman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var datePicker: UIDatePicker?
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.minuteInterval = 5
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        inputTextField.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }

    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        inputTextField.text = dateFormatter.string(from: datePicker.date)
    }

}

