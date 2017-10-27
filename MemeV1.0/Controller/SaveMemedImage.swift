//
//  SaveMemedImage.swift
//  MemeV1.0
//
//  Created by scythe on 10/6/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    //Saves the image to meme
    func save(){
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        if editMeme != nil{
            saveAtAppDelegate(meme: meme)
        }else{
            
            saveAtAppDelegate(meme: meme)
        }
 
    }
    
    func saveAtAppDelegate(meme:Meme){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let editMeme = editMeme{
            if let indexPath = appDelegate.memes.index(of: editMeme){
                print("EDIT SAVE")
                appDelegate.memes.remove(at: indexPath)
                appDelegate.memes.insert(meme, at: indexPath)
            }
        }else{
            appDelegate.memes.append(meme)
        }
    }
    
    //Creates a picture with textField removing first the ToolBars
    func generateMemedImage() -> UIImage{
        
        toolBarIsHidden(set: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBarIsHidden(set: false)
        
        return memedImage
    }
    
    func toolBarIsHidden(set: Bool ){
        
        topToolBar.isHidden = set
        bottomToolBar.isHidden = set
    }
    
}
