//
//  ViewController.swift
//  MemeV1.0
//
//  Created by scythe on 10/6/17.
//  Copyright © 2017 Panagiotis Siapkaras. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIBarPositioningDelegate ,UIPopoverPresentationControllerDelegate {
    
     private struct Alerts {
        
        static let cancelAlert = "Are you sure?"
        static let cancelMessage = "Are you sure about canceling all the changes? If you press OK you will loose all the changes!"
        static let saveErrorTitle = "Internal Error. Unable to Save!!"
        static let imageErrorLoadTitle = "Photo library Error."
        static let imageErrorLoadMessage = " There was an error Loading you photo from the library. Please contact us"
        
    }
    
    // 2 states of photo Input
    private enum photoInput {
        case camera
        case photoLibrary
    }

    
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var titleButton: UIBarButtonItem!
    
    @IBOutlet weak var fontButton: UIBarButtonItem!
    @IBOutlet weak var colorButton: UIBarButtonItem!
    
    
    private var fontName = "HelveticaNeue-CondensedBlack"
    private var fontSize : Float = 40.0
    private var redColor : Float = 255.0
    private var greenColor : Float = 255.0
    private var blueColor : Float = 255.0
    
    private var titleLabel = UILabel(frame: CGRect.zero)
    private let textFieldDelegate = TextFieldSetup()
    
    
    var editMeme : Meme?
    
    //3 different states having 2 popUpControllers
    private enum popUpControllers {
        case PopUpTextPickerViewController , PopUpColorViewController , None
    }
    
    //3 different notifications
    private enum notifications{
        case keyboard , popUpTextPickerViewController , popColorViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        
        if let editMeme = editMeme{
            
            setupTextFields(name: topTextField, textInput: editMeme.topText, fontName: fontName, fontSize: fontSize, redColor: redColor, greenColor: greenColor, blueColor: blueColor)
            setupTextFields(name: bottomTextField, textInput: editMeme.bottomText, fontName: fontName, fontSize: fontSize, redColor: redColor, greenColor: greenColor, blueColor: blueColor)
            self.imageView.image = editMeme.originalImage
        }else{
            
            setupTextFields(name: topTextField, textInput: "TOP", fontName: fontName, fontSize: fontSize, redColor: redColor, greenColor: greenColor, blueColor: blueColor)
            setupTextFields(name: bottomTextField, textInput: "BOTTOM", fontName: fontName, fontSize: fontSize, redColor: redColor, greenColor: greenColor, blueColor: blueColor)
        }
        
        
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = .center
        titleButton.customView = titleLabel
        titleLabel.text = "MEME v2.0"
        titleLabel.font = UIFont(name: "Kefa", size: 20)!
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shareButton.isEnabled = imageView.image != nil
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToNotifications(notification: .keyboard)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotifications(notification: .keyboard)
        unsubscribeFromNotifications(notification: .popColorViewController)
        unsubscribeFromNotifications(notification: .popUpTextPickerViewController)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubViews")
        //popoverPresentationController?.presentingViewController.preferredContentSize = CGSize(width: view.bounds.width, height: 0)
     
        
    }
    
    @IBAction func doneTextField(){
        unsubscribeFromNotifications(notification: .popColorViewController)
        unsubscribeFromNotifications(notification: .popUpTextPickerViewController)
        print("TAPPED")
    }

    //IBAction that get photos from library
    @IBAction func pickImageLibrary(_ sender: UIBarButtonItem) {
        chooseSourceType(sourceType: .photoLibrary)
        
    }
    
    //IBAction that get photos from camera
    @IBAction func pickImageCamera(_ sender: UIBarButtonItem) {
        
       chooseSourceType(sourceType: .camera)
        
    }
    
    private func chooseSourceType(sourceType : photoInput ){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch sourceType{
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
            
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Setup function for the textFields
     private func setupTextFields(name textField: UITextField , textInput text:String , fontName name : String , fontSize : Float, redColor : Float , greenColor : Float , blueColor : Float){
        let memeTextAtributes : [String:Any] = [NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
                                                NSAttributedStringKey.foregroundColor.rawValue : UIColor(red: CGFloat(redColor/255.0), green: CGFloat(greenColor/255.0), blue: CGFloat(blueColor/255.0), alpha: 1.0),
                                                NSAttributedStringKey.font.rawValue : UIFont(name: fontName,size:CGFloat(fontSize))!,
                                                NSAttributedStringKey.strokeWidth.rawValue : -2.0]
        textField.text = text
        textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = memeTextAtributes
        textField.textAlignment = .center
        bottomHeight.constant = CGFloat(1.25 * fontSize) 
        topHeight.constant = CGFloat(1.25 * fontSize)
        
        
    }
    
    
    
    //Fires up the ActivityController
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity , success , items , error in
        
            
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
            
            if error != nil {
                self.showAlert(title: Alerts.saveErrorTitle, message: String(describing:error))
            }
            
        }
        present(activityController, animated: true, completion: nil)
    }
    
    //Cancel button bring sets everything back to start TextFields and ImageView
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        if imageView.image == nil {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.showAlert(title: Alerts.cancelAlert, message: Alerts.cancelMessage)
        }
        
    }
    
    
    //alert function for all the alerts
    private func showAlert(title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if cancelButton.isEnabled {
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                
                self.setupTextFields(name: self.topTextField, textInput: "TOP", fontName: self.fontName, fontSize: self.fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
                self.setupTextFields(name: self.bottomTextField, textInput: "BOTTOM", fontName: self.fontName, fontSize: self.fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
                self.imageView.image = nil
                self.dismiss(animated: true, completion: nil)
                
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
        }else{
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    //takes a notification as an argument and the value (* fontName *) that comes with it updates the ViewController
    @objc func pickerChagned(notification : Notification){
        if let fontName = notification.userInfo!["fontName"] as? String{
            self.fontName = fontName
            self.setupTextFields(name: topTextField, textInput: topTextField.text!, fontName: self.fontName, fontSize: self.fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
            self.setupTextFields(name: bottomTextField, textInput: bottomTextField.text!, fontName: self.fontName, fontSize: self.fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
        }
    }
    
    //takes a notification as an argument and the value (* fontSize *) that comes with it updates the ViewController
    @objc func sliderChanged(notification:Notification){
        if let fontSize = notification.userInfo!["fontSize"] as? Float{
            self.fontSize = fontSize
            self.setupTextFields(name: topTextField, textInput: topTextField.text!, fontName: self.fontName, fontSize: self.fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
            self.setupTextFields(name: bottomTextField, textInput: bottomTextField.text!, fontName: self.fontName, fontSize: self.fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
        }
    }
    
    
    // subscribes to all notification according the need
    private func subscribeToNotifications(notification: notifications){
        switch notification{
        case .keyboard :
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
            //NotificationCenter.default.addObserver(self, selector: #selector(setPopUpAway(notification:)), name: .textEditStarted, object: nil)
        case .popColorViewController:
            NotificationCenter.default.addObserver(self, selector: #selector(sliderColorChanged(notification:)), name: .slidersColorChanged, object: nil)
        case .popUpTextPickerViewController:
            NotificationCenter.default.addObserver(self, selector: #selector(pickerChagned(notification:)) , name: .pickersChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(sliderChanged(notification:)), name: .slidersChanged, object: nil)
        }
    }
    
    @objc func setPopUpAway(notification : Notification){
//        var presentedController : UIViewController! = self.presentingViewController
//        if presentedController is UIPopoverPresentationController{
//            presentedController.dismiss(animated: true) {
//                print("Panos")
//                NotificationCenter.default.removeObserver(self, name: .textEditStarted, object: nil)
//            }
//        }
//
        
    }
    
    
    
    //unsubscribe from the notification according the need
    private func unsubscribeFromNotifications(notification : notifications){
        switch notification{
        case .keyboard :
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        case .popColorViewController:
            NotificationCenter.default.removeObserver(self, name: .slidersColorChanged, object: nil)
        case .popUpTextPickerViewController:
            NotificationCenter.default.removeObserver(self, name: .pickersChanged, object: nil)
            NotificationCenter.default.removeObserver(self, name: .slidersChanged, object: nil)
        }
    }
    
    
    
    @objc private func sliderColorChanged(notification: Notification){
        if let redValue = notification.userInfo!["redValue"] as? Float, let greenValue = notification.userInfo!["greenValue"] as? Float ,let blueValue = notification.userInfo!["blueValue"] as? Float {
            self.redColor = redValue
            self.greenColor = greenValue
            self.blueColor = blueValue
            
            setupTextFields(name: topTextField, textInput: topTextField.text!, fontName: fontName, fontSize: fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
            setupTextFields(name: bottomTextField, textInput: bottomTextField.text!, fontName: fontName, fontSize: fontSize, redColor: self.redColor, greenColor: self.greenColor, blueColor: self.blueColor)
        }
    }
    
    
    //Changes the constraint from the  + 100 so the PopUpTextPickerViewController can show under
    private func increaseBottomTextFieldConstraint(){
        
        bottomConstraint.constant += 100
    }
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {

        if popoverPresentationController.presentingViewController is PopUpTextPickerViewController{
            let viewFrame = popoverPresentationController.presentingViewController.view.frame
            
            let newRect = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y, width: self.view.bounds.width, height: 100)
            let newView = UIView(frame: newRect)
            rect.pointee =  newRect
            view.pointee = newView
            rect.initialize(to: newRect)
            
            
        }
        print("popoverPresentation:willRepositionPopOverTo")
    }
    
    
    func textFieldsEnable(){
        //TODO: - Fix function that enable and disables the textFields according the popOvers
        //Fix Notifications from textField Delegate
        //If textFields are editing send Notification from textfieldSetup that FontButton.isEnable = false and fontColor.isEnable = false
        //Remove observer from shouldReturn TextFieldSetup
    }
    
    //Shows the PopUpTextPickerViewController on the screen
    @IBAction func fontButtonPressed(_ sender: UIBarButtonItem) {
        //TODO: -Fix textField Enable / disable if the pop Over is Showend
        //Enable when disable the popOver
        subscribeToNotifications(notification: .popUpTextPickerViewController)
        let fontController = storyboard?.instantiateViewController(withIdentifier: "popUpTextPickerViewController") as! PopUpTextPickerViewController
        fontController.fontName = self.fontName
        fontController.fontSize = self.fontSize
        fontController.modalPresentationStyle = UIModalPresentationStyle.popover
        fontController.popoverPresentationController?.delegate = self
        fontController.popoverPresentationController?.barButtonItem = fontButton
        fontController.popoverPresentationController?.backgroundColor = .clear
        fontController.popoverPresentationController?.sourceView = self.view
        fontController.preferredContentSize = CGSize(width: self.view.bounds.width, height: 100)
        present(fontController, animated: true, completion: nil)
    }
    
    // Shows the PopColorViewControler on the screen.
    @IBAction func colorButtonPressed(_ sender: UIBarButtonItem) {

        subscribeToNotifications(notification: .popColorViewController)
        let colorController = storyboard?.instantiateViewController(withIdentifier: "popColorViewController") as! PopColorViewController
        colorController.modalPresentationStyle = UIModalPresentationStyle.popover
        colorController.popoverPresentationController?.delegate = self
        colorController.popoverPresentationController?.backgroundColor = .clear
        colorController.blueValue = self.blueColor
        colorController.redValue = self.redColor
        colorController.greenValue = self.greenColor
        colorController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        colorController.popoverPresentationController?.sourceView = self.view
        colorController.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width, y: self.view.frame.midY, width: 0, height: 0)
        present(colorController, animated: true, completion: nil)
    }
    
    //Its always get trigged when a popOverController is about to present. We make changes acconding the 2 different popUpControllers we have
    // PopUpTextPickerViewController calls rightBottomToolBarEnable to Enable/disable the  buttons and reposition the bottomTextField
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if popoverPresentationController.presentedViewController is PopUpTextPickerViewController{
            rightBottomToolBarEnable(popUpController: .PopUpTextPickerViewController)
            increaseBottomTextFieldConstraint()
        }else if popoverPresentationController.presentedViewController is PopColorViewController{
            rightBottomToolBarEnable(popUpController: .PopUpColorViewController)
        }
    }
    
    //its always trigged after the popOver is Dismissed. We placing the bottomTextContraint back to position and set the buttons with rightBottomToolBarEnable to .None
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if popoverPresentationController.presentedViewController is PopUpTextPickerViewController{
            bottomConstraint.constant -= 100
        }
        rightBottomToolBarEnable(popUpController: .None)
        
    }

    //Navigation
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //Enables and disaples the right bottom bar items according which one is pressed
    private func rightBottomToolBarEnable(popUpController: popUpControllers){
        switch popUpController{
        case .PopUpTextPickerViewController:
            colorButton.isEnabled = false
        case .PopUpColorViewController:
            fontButton.isEnabled = false
        case .None:
            fontButton.isEnabled = true
            colorButton.isEnabled = true
            
        }
    }

}


//----------------------        extensions          ----------------------//


extension ViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }else{
            showAlert(title: Alerts.saveErrorTitle, message: Alerts.imageErrorLoadMessage )
        }
        
        dismiss(animated: true, completion: nil)
    }
}






















