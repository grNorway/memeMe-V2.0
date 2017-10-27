//
//  MemesCollectionViewController.swift
//  MemeV1.0
//
//  Created by scythe on 10/17/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit


class MemesCollectionViewController: UICollectionViewController {

    //MARK: - Properties
    @IBOutlet private weak var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    
    fileprivate var memes = [Meme]()
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var itemsPerRow: CGFloat = 3
    fileprivate let insets = UIEdgeInsets(top: 5, left: 5, bottom: 3, right: 5)
    fileprivate var isEditingMode = false
    fileprivate var selectedItems = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewWillAppear")
        resetSelection()
        
        memes = appDelegate.memes
         print(isEditingMode)
        enableLeftBarButtonItem()
        collectionView?.reloadData()
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    //Set up the collectionItem to show the picture of memes only
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionViewCell
    
        let meme = memes[indexPath.row]
        
        cell.collectionImageView.image = meme.memedImage
        cell.selectedImage.isHidden = true
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    
    //when the collectionViewItem is Deselected we remove the item IndexPath to a selectedItems Array
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if isEditingMode{
        
        guard collectionView.allowsMultipleSelection else { return }
        guard selectedItems.count != 0 else { return}
            let cell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
            let item = itemForIndexPath(indexPath: indexPath)
        
            if let index = memes.index(of: item){
                if index != 0{
                selectedItems.remove(at: index - 1)
                }else{
                    selectedItems.remove(at: index)
                }
            }
            cell.toggleSelectionLabel()
        }
        
    }
    
    //when the collectionViewItem is selected we adding the item IndexPath to a selectedItems Array
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditingMode{
            guard collectionView.allowsSelection else { return }
            guard collectionView.allowsMultipleSelection else { return }
            let cell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
            let item = itemForIndexPath(indexPath: indexPath)
            selectedItems.append(item)
            cell.toggleSelectionLabel()
        }else{
            performSegue(withIdentifier: "showPicture", sender: indexPath)
        }
    }
    
    
    //Connect to viewController to insert picture
    @IBAction func photoAction(_ sender: UIBarButtonItem) {
        
        let photoController = self.storyboard?.instantiateViewController(withIdentifier: "photoMemeEditor") as! ViewController
        present(photoController, animated: true, completion: nil)
        
    }
    //This Action is not working ///// check later
    //    @IBAction func editButton(_ sender: UIBarButtonItem) {
//
//       print("Edit button pressed")
//        if editButton.isEnabled{
//
//            isEditingMode = true
//            print(isEditingMode)
//            print("INNNN \(isEditingMode)")
//            collectionView?.allowsMultipleSelection = true
//            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deleteSelectedItems))
//
//        }
//    }
    
    
    //deletes the selected items from our main array
    @objc func deleteSelectedItems(){
        
        for meme in memes {
            for selectedItem in selectedItems{
                if meme == selectedItem{
                    if let index = memes.index(of: meme){
                        appDelegate.memes.remove(at: index)
                        memes.remove(at: index)
                    }
                }
            }
        }
        
        collectionView?.reloadData()
        collectionView?.allowsMultipleSelection = false
        
        selectedItems.removeAll()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:#selector(editBarButton))
        enableLeftBarButtonItem()
        isEditingMode = false
        collectionView?.allowsSelection = true
        
    }
    
    //sets the correct title for the leftbarbutton title from Done -> Edit
    @objc private func editBarButton(){
        
        isEditingMode = true
        print(isEditingMode)
        collectionView?.allowsMultipleSelection = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deleteSelectedItems))
        enableLeftBarButtonItem()
    }
    //return an item at specific indexPath
    private func itemForIndexPath(indexPath : IndexPath) -> Meme{
        return memes[indexPath.row]
    }
    
    //checks about the availability of the LeftButtonItem at navigationcontroller
    private func enableLeftBarButtonItem(){
        navigationItem.leftBarButtonItem!.isEnabled = memes.count != 0
    }
    
    //Resets the selection in 
    private func resetSelection(){
        selectedItems = [Meme]()
        enableLeftBarButtonItem()
        deleteSelectedItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPicture" {
            let detailController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            detailController.memeObject = memes[indexPath.row]
        }
    }
 
    
}





// CollectionViewDelegate
extension MemesCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    //This function calculates all the time the size of the item in the collectionView and return the according size of the orientation!!!
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = insets.left * (itemsPerRow + 1)
        let availableWidth = self.view.bounds.width - paddingSpace
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    //Return the minimumLineSpacing For row or column of the a section. Because we want to have the same with the PaddingSpace we use the same calculation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.left * (itemsPerRow + 1)
    }

}











