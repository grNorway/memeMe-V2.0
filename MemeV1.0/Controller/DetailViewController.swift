//
//  DetailViewController.swift
//  MemeV1.0
//
//  Created by scythe on 10/21/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var memeObject : Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        imageView.image = memeObject.memedImage
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editPhoto))
    }
    
    @objc func editPhoto(){
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "photoMemeEditor") as! ViewController
        viewController.editMeme = memeObject
        present(viewController, animated: true, completion: nil)
    }

    
}
