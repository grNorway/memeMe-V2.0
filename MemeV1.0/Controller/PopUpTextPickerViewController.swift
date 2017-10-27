//
//  PopUpTextPickerViewController.swift
//  MemeV1.0
//
//  Created by scythe on 10/20/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit
import Foundation


class PopUpTextPickerViewController: UIViewController{

    //MARK: - Properties

    @IBOutlet weak var fontPicker: UIPickerView!
    var fontName : String!
    let fonts = ["HelveticaNeue-CondensedBlack","HoeflerText-BlackItalic","Party LET","Marion-Bold","Savoye Let","Superclarendon-LightItalic","AmericanTypewriter"]
    
    @IBOutlet weak var sizeSlider: UISlider!
    var fontSize : Float!
    let rotate : CGFloat = CGFloat(-90 * (Double.pi / 180))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        fontPicker.transform = CGAffineTransform(rotationAngle: rotate)
        
        //TODO: -fix the width to cover the whole screen
        fontPicker.frame = CGRect(x: -100, y: 20, width: view.frame.width + 200, height: 30)
        view.backgroundColor = UIColor.clear
        updateFontPicker(fontName: fontName)
        sizeSlider.setThumbImage(UIImage(named: "fontResize3"), for: .normal)
        sizeSlider.value = fontSize
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.frame.size = CGSize(width: view.bounds.size.width, height: 100)
    }
 
    // Setup the fonts for each picker row text
    func setupPickerTextFont(label : UILabel , row : Int) -> UILabel {
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        
        let pickerText = "Pick a Font"
        let attributes : [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeColor.rawValue) : UIColor.black,
                                                          NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: fonts[row],size:30)!,
                                                          NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeWidth.rawValue) : -2.0]
        let attributedString = NSAttributedString(string: pickerText, attributes: attributes)
        label.attributedText = attributedString
        label.transform = CGAffineTransform(rotationAngle: -rotate)
        return label
    }
    
    //Updated the picker always to show the current Font(from viewController)
    private func updateFontPicker(fontName : String){
        for (index,name) in fonts.enumerated(){
            if name == fontName{
                fontPicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        let sliderValueDict : [String : Float] = ["fontSize": sizeSlider.value]
        NotificationCenter.default.post(name: .slidersChanged, object: self, userInfo: sliderValueDict)
    }
    
    
    
    

}
