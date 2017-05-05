//
//  EditProfileController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 09/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK : - Properties
    var storageReference : FIRStorageReference!
    var databaseReference : FIRDatabaseReference!
    
    // MARK : - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storageReference = DatabaseReference.getStorageRef()
        self.databaseReference = DatabaseReference.getDatabaseRef()
        self.setupProfileImageView()
        self.setFields()
        self.setupChangePasswordButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - View Methods
    func setupChangePasswordButton() {
        self.changePasswordButton.layer.borderWidth = 1
        self.changePasswordButton.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1).cgColor
        self.changePasswordButton.layer.cornerRadius = 5
    }
    
    func setFields() {
        self.profileImageView.image = User.sharedInstance.user.profileImage
        self.nameTextField.text = User.sharedInstance.user.name
        self.emailTextField.text = User.sharedInstance.user.email
    }
    
    func setupProfileImageView() {
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileImageView.clipsToBounds = true
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = 30
    }
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            self.profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveNewName() {
        if self.nameTextField.text != User.sharedInstance.user.name {
            let updateName = ["name" : self.nameTextField.text as Any]
            let userId = FIRAuth.auth()?.currentUser?.uid
            let usersReference = self.databaseReference.child("users").child(userId!)
            usersReference.updateChildValues(updateName)
            User.sharedInstance.user.name = self.nameTextField.text
        }
    }
    
    func saveNewProfilePhoto() {
        if self.profileImageView.image != User.sharedInstance.user.profileImage {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            User.sharedInstance.user.profileImage = self.profileImageView.image
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                let imageName = NSUUID().uuidString
                storageReference.child("profile_images").child("\(imageName).png").put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        SimpleAlert.showAlert(vc: self, title: "Error", message: "\(error)")
                        return
                    }
                    let updateProfileImage = ["profileImage" : metadata?.downloadURL()?.absoluteString as Any]
                    let userId = FIRAuth.auth()?.currentUser?.uid
                    let usersReference = self.databaseReference.child("users").child(userId!)
                    usersReference.updateChildValues(updateProfileImage)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            }
        }
    }

    
    // MARK : - View Actions
    @IBAction func changeImageAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alterar foto de perfil", message: nil, preferredStyle: .actionSheet)
        let selectOnLibraryAction = UIAlertAction(title: "Escolher na biblioteca", style: .default) { (action) in
            self.presentImagePicker()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let removeImageAction = UIAlertAction(title: "Remover foto atual", style: .destructive) { (action) in
            print("Error")
        }
        alert.addAction(selectOnLibraryAction)
        alert.addAction(cancelAction)
        alert.addAction(removeImageAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveUserChanges(_ sender: UIBarButtonItem) {
        self.saveNewName()
        self.saveNewProfilePhoto()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: User.sharedInstance.user.email!) { error in
            if let error = error {
                print(error)
            } else {
                SimpleAlert.showAlert(vc: self, title: "Redefinir senha", message: "Foi enviado em seu email as etapas para a redefinição de sua senha!")
            }
        }
    }
    

}








