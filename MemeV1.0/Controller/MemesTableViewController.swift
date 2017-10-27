//
//  MemesTableViewController.swift
//  MemeV1.0
//
//  Created by scythe on 10/16/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {

    //MARK: - Properties
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var memes = [Meme]()
    private var selectedItems = [Meme]()
    private var isEditingTableView = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register xib file to tableView as cell
        let cellTableViewXib = UINib(nibName: "MemeTableViewCell", bundle: nil)
        tableView.register(cellTableViewXib, forCellReuseIdentifier: "MemeTableViewCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //self.navigationItem.leftBarButtonItem = editButtonItem
        
        memes = appDelegate.memes
        print(memes.count)
        resetSelection()
        tableView.reloadData()
        leftButtonItemIsEnable()
        print("viewWillAppear")
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if memes.count == 0 {
            return 0
        }else{
            return memes.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell

        let meme = memes[indexPath.row]
        
        cell.configureCell(meme: meme)
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath.row)
            
            
            memes.remove(at: indexPath.row)
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            leftButtonItemIsEnable()
            
        }
    }
    
    //it checks when the row is selected and if isEditingTableView mode  true then it adds the cells with accessory type to a array to delete them later or deselect and remove from the array that was selected previous
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        if isEditingTableView{
            let cell = tableView.cellForRow(at: indexPath) as! MemeTableViewCell
            let item = itemForIndexPath(indexPath: indexPath)
            
            if cell.accessoryType != .checkmark{
                selectedItems.append(item)
                cell.toggleTableCell(cell: cell)
            }else{
                cell.toggleTableCell(cell: cell)
                if let index = memes.index(of: item){
                    if index != 0{
                        selectedItems.remove(at: index - 1)
                    }else{
                        selectedItems.remove(at: index)
                    }
                }
            }
            
            leftButtonItemIsEnable()
        }else{
            performSegue(withIdentifier: "showPicture", sender: indexPath)
        }
        
    }
    
    private func itemForIndexPath(indexPath : IndexPath) -> Meme{
        
        return memes[indexPath.row]
    }
    
    //Make enable/Disable the edit button if the tableView is empty of not
    private func leftButtonItemIsEnable(){
        navigationItem.leftBarButtonItem?.isEnabled = memes.count != 0
    }
    
   //Opens the ViewController to add photo from Library or Camera
    @IBAction func photoAction(_ sender: UIBarButtonItem) {
        
        let photoMemeEditor = self.storyboard?.instantiateViewController(withIdentifier: "photoMemeEditor") as! ViewController
        
        self.present(photoMemeEditor, animated: true, completion: nil)
        
    }
    
    //when edit button pressed its enabling the editingMode to true and remanes the buttonTitle to Done with the specified targe (deleteSelectedRows() )
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if !isEditingTableView{
            isEditingTableView = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deleteSelectedRows))
        }else{
            isEditingTableView = false
        }
    }
    
    //Deletes the selected Rows
    @objc func deleteSelectedRows(){
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
        self.tableView.reloadData()
        selectedItems.removeAll()
        self.isEditingTableView = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed(_:)))
        leftButtonItemIsEnable()
    }
    
    private func resetSelection(){
        
        selectedItems.removeAll()
        deleteSelectedRows()
        //leftButtonItemIsEnable()
    }
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPicture"{
            let detailViewController = segue.destination as! DetailViewController
            let indexPath =  sender as! IndexPath
            detailViewController.memeObject = memes[indexPath.row]
            
        }
    }
    
}












