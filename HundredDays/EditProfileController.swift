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
    var user : User!
    
    // MARK : - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storageReference = DatabaseReference.getStorageRef()
        self.databaseReference = DatabaseReference.getDatabaseRef()
        self.profileImageView.image = self.user.profileImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - View Actions
    @IBAction func changeImageAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alterar foto de perfil", message: nil, preferredStyle: .actionSheet)
        let selectOnLibraryAction = UIAlertAction(title: "Escolher na biblioteca", style: .default) { (action) in
            self.presentImagePicker()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let removeImageAction = UIAlertAction(title: "Remover foto atual", style: .destructive) { (action) in
            print("removido")
        }
        alert.addAction(selectOnLibraryAction)
        alert.addAction(cancelAction)
        alert.addAction(removeImageAction)
        self.present(alert, animated: true, completion: nil)
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
    
    func savePhoto() {
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
            let imageName = NSUUID().uuidString
            storageReference.child("profile_images").child("\(imageName).png").put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let updateProfileImage = ["profileImage" : metadata?.downloadURL()?.absoluteString]
                let userId = FIRAuth.auth()?.currentUser?.uid
                let usersReference = self.databaseReference.child("users").child(userId!)
                usersReference.updateChildValues(updateProfileImage)
            })
        }
    }
    @IBAction func saveUserChanges(_ sender: UIBarButtonItem) {
        self.savePhoto()
    }
    
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    

}








