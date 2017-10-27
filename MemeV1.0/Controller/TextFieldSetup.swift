//
//  TextFieldSetup.swift
//  MemeV1.0
//
//  Created by scythe on 10/6/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import UIKit

class TextFieldSetup : NSObject,UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
        textField.becomeFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //NotificationCenter.default.post(name: .textEditStarted, object: nil)
        textField.resignFirstResponder()
        return true
    }
    
    
}
