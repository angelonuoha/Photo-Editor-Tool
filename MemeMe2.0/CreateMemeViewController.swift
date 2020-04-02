//
//  CreateMemeViewController.swift
//  MemeMe1.0
//
//  Created by Angel Onuoha on 12/2/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    // MARK: Setup TextField
    func setUpTextField(toTextField textField: UITextField) {
        textField.defaultTextAttributes = memeFont
        textField.textAlignment = .center
        textField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // MARK: Font Details
    let memeFont: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "HelveticaNeue-condensedBlack", size: 30)!,
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .strokeWidth: -3.0
    ]
    
    
    // MARK: Button Actions
    
    func openImage(_ sender: UIBarButtonItem) -> UIViewController {
        let controller = UIImagePickerController()
        if sender.tag == 1 {
            controller.sourceType = .camera
        }
        controller.sourceType = .photoLibrary
        controller.delegate = self
        return controller
    }
    
    @IBAction func openImageFromCamera(_ sender: Any) {
        present(openImage(cameraButton), animated: true, completion: nil)
    }
    
    @IBAction func openImageFromAlbum(_ sender: Any) {
        present(openImage(photoLibraryButton), animated: true, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        let image = [createMeme()]
        let controller = UIActivityViewController(activityItems: image, applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
                return
            }
        }
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        reset()
    }
    
    
    // MARK: Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTextField(toTextField: topTextField)
        setUpTextField(toTextField: bottomTextField)
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        suscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsuscribeToKeyboardNotifications()
    }

    
    // MARK: Accessing Data from Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Hide Tool and Navbars
    
    func hideBar(_ value: Bool) {
        navBar.isHidden = value
        toolBar.isHidden = value
    }
    
    // Create Meme Function
    func createMeme() -> UIImage {
        hideBar(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideBar(false)
        return memedImage
    }
    
    // Reset Function
    func reset() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        shareButton.isEnabled = false
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
    // Save Function
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: createMeme())
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // Keyboard Shift Functions
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func suscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsuscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    
    
}

