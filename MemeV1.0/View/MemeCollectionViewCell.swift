//
//  MemeCollectionViewCell.swift
//  MemeV1.0
//
//  Created by scythe on 10/17/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var selectedImage: UILabel!
    
    
    func toggleSelectionLabel(){
        if !selectedImage.isHidden{
            selectedImage.isHidden = true
        }else{
            selectedImage.isHidden = false
        }
    }
    
}
