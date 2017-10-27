//
//  MemeTableViewCell.swift
//  MemeV1.0
//
//  Created by scythe on 10/16/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTopLabel: UILabel!
    @IBOutlet weak var cellBottomLabel: UILabel!
    
    //attributes for the cellTopLabel/cellBottomLabel string
    let attributes: [NSAttributedStringKey : Any] =
        [NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeColor.rawValue) : UIColor.black,
         NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeWidth.rawValue) : -2.0
    ]
    
    
    //setup the xib cell at the tableView
    func configureCell(meme : Meme){
        
        cellImageView.image = meme.memedImage
        
        setupLabel(label: cellTopLabel, attributes: attributes, text: meme.topText)
        setupLabel(label: cellBottomLabel, attributes: attributes, text: meme.bottomText)
    }
    
    
    //It setup the labels with the attributed String and add the text value to the label
    func setupLabel(label: UILabel , attributes: [NSAttributedStringKey : Any], text: String ){
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        label.text = text
        
    }
    
    func toggleTableCell(cell : UITableViewCell){
        if cell.accessoryType == .none{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
    }

    

}
