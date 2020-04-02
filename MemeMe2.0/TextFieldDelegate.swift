//
//  TextFieldDelegate.swift
//  MemeMe1.0
//
//  Created by Angel Onuoha on 12/2/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: UIViewController, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
}
