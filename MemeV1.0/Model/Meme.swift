//
//  Meme.swift
//  MemeV1.0
//
//  Created by scythe on 10/6/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import Foundation
import UIKit

//Model of Meme
struct Meme{
    
    
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
    
    init(topText: String , bottomText: String,originalImage: UIImage,memedImage : UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

extension Meme : Equatable{
    static func ==(lhs: Meme, rhs: Meme) -> Bool {
        return lhs.memedImage == rhs.memedImage
    }
}






