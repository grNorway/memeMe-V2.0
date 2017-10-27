//
//  PopColorViewController.swift
//  MemeV1.0
//
//  Created by scythe on 10/21/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit


class PopColorViewController: UIViewController {

    
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    
    var redValue : Float!
    var greenValue : Float!
    var blueValue : Float!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            redSlider.value = redValue
            greenSlider.value = greenValue
            blueSlider.value = blueValue
        
    }
    
    @IBAction func changeColorValue(){
        
        let colorValueDict : [String : Float] = ["redValue" : redSlider.value , "greenValue": greenSlider.value , "blueValue":blueSlider.value]
        NotificationCenter.default.post(name: .slidersColorChanged, object: self, userInfo: colorValueDict)
        
    }
    
    

    
    

    

}
