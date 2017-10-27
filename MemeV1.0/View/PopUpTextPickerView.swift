//
//  PopUpTextPickerView.swift
//  MemeV1.0
//
//  Created by scythe on 10/25/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import UIKit

extension PopUpTextPickerViewController : UIPickerViewDelegate{
    
    //setup a reusable row view with a label that can represent a font text in the current font
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = view as? UILabel ?? UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        return setupPickerTextFont(label: label, row: row)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 200
    }
    
    //executes when row is selected from picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let fontNameDict : [String : String] = ["fontName" : fonts[row]]
        NotificationCenter.default.post(name: .pickersChanged, object: self, userInfo: fontNameDict)
    }
    
    
}

extension PopUpTextPickerViewController : UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fonts.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return fonts.count
    }

    
}




