//
//  Keyboard+Notifications.swift
//  MemeV1.0
//
//  Created by scythe on 10/6/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    //keyboard notifications observers / removers are implemet in subscribeToNotifications(notification:)
    
    //checks the which textfield is editing and gets the keyboardHeight from getKeyboardHeight
    @objc func keyboardWillShow(_ notification:Notification){
        if topTextField.isEditing{
            view.frame.origin.y = 0
        }else{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Calculate the keyboardHeight
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    //Sets the view back to 0
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    
}
