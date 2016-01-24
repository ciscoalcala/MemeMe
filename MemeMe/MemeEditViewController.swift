//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by francisco Alcala on 1/16/16.
//  Copyright © 2016 ciscoalcala. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    //MARK: I B OUTLETS
    @IBOutlet weak var spacingConstraintFromTopTextToTopOfImageView: NSLayoutConstraint!
    
    @IBOutlet weak var spacingConstraintFromBottomTextToBottomOfImageView: NSLayoutConstraint!
    
    @IBOutlet weak var widthConstraintOfTopText: NSLayoutConstraint!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    
    
    //MARK: VARS RELATED TO IMAGE SELECTED
    
    //imageSelected will only be called after image has been selected
    var imageSelected: UIImage!
    
    //will be used to reposition top and bottom text views after image is selected, based on aspect fit imageView
    var newWidthBasedOnFullHeight = CGFloat(0.0)
    
    //will be used to reposition top and bottom text views after image is selected, based on aspect fit imageView
    var newHeightBasedOnFullWidth = CGFloat(0.0)
    
    //bool to keep track if the width of imageView is filled, after image has been selected
    var widthIsFilled = true
    
    //will be used to move text views vertically
    var diffInHeightBetweenImageViewAndImageSelected = CGFloat(0.0)
    
    //will be used to create rect for generating meme
    var diffInWidthBetweenImageViewAndImageSelected = CGFloat(0.0)
    
    //will be used when editing an existing meme
    var editingExistingMeme = false
    
    var itemSelected = 0
    
    var firstTimeViewHasAppeared = true
    
    

    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // SET UP TEXTFIELDS PROPERTIES AND ATTRIBUTES
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "impact", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        
        
        // SET UP NOTIFICATIONS FOR SCREEN ORIENTATIONS
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        print("view will appear")
       
        if editingExistingMeme && firstTimeViewHasAppeared{
            print("editing existing meme")
            
            let existingMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[itemSelected]
            
            //set the existing values
            topTextField.text = existingMeme.topText
            bottomTextField.text = existingMeme.bottomText
            imageView.image = existingMeme.originalImage
            imageSelected = existingMeme.originalImage
            
            firstTimeViewHasAppeared = false
            
            topTextField.hidden = true
            bottomTextField.hidden = true
        }


        
        //  ENABLE / DISABLE CAMERA BUTTON DEPENDING ON AVAILABILITY OF DEVICE/SIMULATOR
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            cameraButton.enabled = true
        }
        else{
            cameraButton.enabled = false
        }
        
        //  ENABLE / DISABLE SHARE BUTTON UNTIL IMAGE HAS BEEN LOADED
        if imageView.image == nil{
            shareButton.enabled = false
        }
        else{
            shareButton.enabled = true
            adjustTextViewsAfterImageSelected(imageView.image!)
        }
        
        
        //  SUBSCRIBE TO KEYBOARD SHOW/HIDE NOTIFICAIONS
        subscribeToKeyboardShowNotifications()
        subscribeToKeyboardHideNotifications()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if editingExistingMeme{
            adjustTextViewsAfterImageSelected(imageSelected)
            topTextField.hidden = false
            bottomTextField.hidden = false
        }

        

    }

    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //  UNSUBSCRIBE FROM KEYBOARD NOTIFICATIONS
        unsubscribeFromKeyboardShowNotifications()
        unsubscribeFromKeyboardHideNotifications()
        
        //  END GENERATING DEVICE ORIENTATION NOTIFICATIONS
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        
        
    }
    
    
    
    
    //MARK: KEYBOARD WILL SHOW NOTIFICATIONS
    func subscribeToKeyboardShowNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        //ONLY MOVE THE VIEW UP IF THE BOTTOM TEXT FIELD IS ACTIVE
        if bottomTextField.isFirstResponder(){
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
        else{
            view.frame.origin.y = 0
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    
    //MARK: KEYBOARD WILL HIDE NOTIFICATIONS
    func subscribeToKeyboardHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    
    
    //MARK: I B ACTIONS
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        //if image view is nil
        //meme edit view controller will dismiss itself
        if imageView.image == nil{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{
            //else, resets the textfields and image
            topTextField.text = "TOP TEXT"
            bottomTextField.text = "BOTTOM TEXT"
            imageView.image = nil
            shareButton.enabled = false
        
        }
    
        
    }
    
    
    
    @IBAction func share(sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        presentViewController(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
    }
    
    

    
    //MARK: MEME GENERATING, SAVING
    func generateMemedImage()->UIImage{
        
        if widthIsFilled{ //for portrait mode
            
            //define the rect of the imageView to be just the visible image not the entire imageView
            let imageViewRect = CGRectMake(0.0, 0.0, view.bounds.size.width, newHeightBasedOnFullWidth)
            imageView.bounds = imageViewRect

            //define the rect of the topTextView
            let topTextRect = CGRectMake(0, 0, topTextField.bounds.size.width, topTextField.bounds.size.height)

            //define the rect of the bottomTextView
            let bottomTextRect = CGRectMake(0, (newHeightBasedOnFullWidth - bottomTextField.bounds.size.height), bottomTextField.bounds.size.width, bottomTextField.bounds.size.height)


            //BEGIN IMAGE CONTEXT
            UIGraphicsBeginImageContextWithOptions(imageViewRect.size, true, 0.0)
            
            
            imageView.drawViewHierarchyInRect(imageViewRect, afterScreenUpdates: true)
            
            topTextField.drawViewHierarchyInRect(topTextRect, afterScreenUpdates: true)
            
            bottomTextField.drawViewHierarchyInRect(bottomTextRect, afterScreenUpdates: true)
        
            
            let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            //END IMAGE CONTEXT
            
            
            return memedImage
            
            
        }
            
        else{ //height is filled, for landscape mode
            
            //define the rect of the imageView to be just the visible image not the entire imageView
            let imageViewRect = CGRectMake(0.0, 0.0, view.bounds.size.width, newHeightBasedOnFullWidth)
            imageView.bounds = imageViewRect
            
            //define the rect of the topTextView
            let topTextRect = CGRectMake(((imageView.bounds.size.width - topTextField.bounds.size.width) * 0.5), 0, topTextField.bounds.size.width, topTextField.bounds.size.height)
            
            //define the rect of the bottomTextView
            let bottomTextRect = CGRectMake(((imageView.bounds.size.width - bottomTextField.bounds.size.width) * 0.5), (newHeightBasedOnFullWidth - bottomTextField.bounds.size.height), bottomTextField.bounds.size.width, bottomTextField.bounds.size.height)

            
            //BEGIN IMAGE CONTEXT
            UIGraphicsBeginImageContextWithOptions(imageViewRect.size, true, 0.0)
            
            
            imageView.drawViewHierarchyInRect(imageViewRect, afterScreenUpdates: true)
            
            topTextField.drawViewHierarchyInRect(topTextRect, afterScreenUpdates: true)
            
            bottomTextField.drawViewHierarchyInRect(bottomTextRect, afterScreenUpdates: true)
            
            
            let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            //END IMAGE CONTEXT
            
            
            return memedImage
            
        }
        
        
        
    }
    
    
    
    func save(memedImage: UIImage) {
        
        //CREATE THE MEME
        let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:imageView.image!, memedImage: memedImage)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate

        
        if editingExistingMeme{
            //REPLACE THE MEME IN THE MEMES ARRAY STORED IN APP DELEGATE
            appDelegate.memes.removeAtIndex(itemSelected)
            appDelegate.memes.insert(meme, atIndex: itemSelected)
        }
            
            
        else{
            //ADD THE MEME TO THE MEMES ARRAY STORED IN APP DELEGATE
            appDelegate.memes.append(meme)
        }

        
    }

    
    
    //MARK: IMAGE PICKER CONTROLLER DELEGATE METHODS
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageView.image = image
            
            imageSelected = image
            
        }
        
        
    }
    
        
    
    
    
    //MARK:  WHEN SCREEN IS ROTATED - UTILITY FUNCTIONS
    func rotated(){
        
        if imageView.image == nil{
            //no need to adjust text views
        }
        else{
            adjustTextViewsAfterImageSelected(imageView.image!)
        }
        
    }
    
    
    func adjustTextViewsAfterImageSelected(selectedImage: UIImage){
        
        //first determine if the image selected will fill the width or height
        isWidthFilled(imageSelected.size.width, heightOfImageSelected: imageSelected.size.width)
        
        if widthIsFilled{
            
            print("width is filled")
            
            //find the difference in heights
            diffInHeightBetweenImageViewAndImageSelected = whatIsTheDiffInHeightBetweenImageViewAndImageSelected()
            
            
            //textViews will be adjusted vertically
            spacingConstraintFromTopTextToTopOfImageView.constant = diffInHeightBetweenImageViewAndImageSelected
            spacingConstraintFromBottomTextToBottomOfImageView.constant = diffInHeightBetweenImageViewAndImageSelected * -1
            
            
            //topTextView will have its length reset to the width of the imageView
            //bottomTextView is constrained to match the length of top text view
            widthConstraintOfTopText.constant = imageView.frame.width
            
            //this will redraw the view to update the text view locations and lengths
            view.setNeedsDisplay()
        
        }
            
            
        else{ //height is filled
            print("height is filled")
            
            //find the difference in widths
            diffInWidthBetweenImageViewAndImageSelected = whatIsTheDiffInWidthBetweenImageViewAndImageSelected()
            
            //text length will be adjusted to match width of image that was calculated
            widthConstraintOfTopText.constant = newWidthBasedOnFullHeight
            
            //reset the locations of top and bottom text views
            spacingConstraintFromTopTextToTopOfImageView.constant = 0.0
            spacingConstraintFromBottomTextToBottomOfImageView.constant = 0.0
            
            //this will redraw the view to update the text view locations and lengths
            view.setNeedsDisplay()
        
        }
        
    }
    
    
    func isWidthFilled(widthOfImageSelected: CGFloat, heightOfImageSelected: CGFloat){
        
        //calculate the new width of image if the height is filled
        newWidthBasedOnFullHeight = (imageView.frame.size.height / imageSelected.size.height) * imageSelected.size.width
        
        //calculate the new height of image if the widht is filled
        newHeightBasedOnFullWidth = (imageView.frame.size.width / imageSelected.size.width) * imageSelected.size.height
        
        if newHeightBasedOnFullWidth < imageView.frame.size.height{
            widthIsFilled = true
        }
        else{
            widthIsFilled = false
        }
        
    }
    
    
    func whatIsTheDiffInHeightBetweenImageViewAndImageSelected() -> CGFloat{
        
        //(full height of imageView container - calculated height) * 0.5
        //0.5 because diff will be split above and below image selected
        let diff = (imageView.frame.height - newHeightBasedOnFullWidth) * 0.5
        return (diff)
    }
    
    
    func whatIsTheDiffInWidthBetweenImageViewAndImageSelected() -> CGFloat{
        
        //(full width of imageView container - calculated width) * 0.5
        //0.5 because diff will be split on each side of image selected
        return ((imageView.frame.width - newWidthBasedOnFullHeight) * 0.5)
    }
    
    
    
    //MARK: TEXT FIELD DELEGATE METHODS
    func textFieldDidBeginEditing(textField: UITextField) {
        topTextField.clearsOnBeginEditing = true
        textField.text = ""
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        //REPLACES AN EMPTY TEXTFIELD WITH THE DEFAULT TEXT
        if topTextField.text == ""{
            topTextField.text = "TOP TEXT"
        }
        
        if bottomTextField.text == ""{
            bottomTextField.text = "BOTTOM TEXT"
        }
        
        //CHANGES ANY LOWERCASE STRING TO UPPERCASE
        textField.text = textField.text!.uppercaseString
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    
    
    
    
    

}

