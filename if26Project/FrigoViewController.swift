//
//  FrigoViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 29/11/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit
import Foundation
import SQLite3

class FrigoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var ingredientField: UITextField!
    @IBOutlet weak var frigoPicker: UIPickerView!
    var values = ["123 Main Street", "789 King Street", "456 Queen Street", "99 Apple Street"]
    

    // If user changes text, hide the tableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frigoPicker.delegate = self
        frigoPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.ingredientField.text = self.values[row]
        self.frigoPicker.isHidden = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.ingredientField {
        self.frigoPicker.isHidden = false
        textField.endEditing(true)
        }
    }

    
}





