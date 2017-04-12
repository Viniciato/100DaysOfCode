//
//  RegisterController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 08/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController, UITextFieldDelegate {
    
    // MARK : - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK : - Properties
    var databaseReference : FIRDatabaseReference!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        self.setupRegisterButton()
        self.databaseReference = DatabaseReference.getDatabaseRef()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - View Methods
    func setupTextFields() {
        self.emailTextField.delegate = self
        self.nameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.nameTextField.autocorrectionType = .no
        self.passwordTextField.isSecureTextEntry = true
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.keyboardType = .emailAddress
        self.passwordTextField.autocorrectionType = .no
    }
    
    func setupRegisterButton(){
        self.registerButton.layer.cornerRadius = 5
    }
    
    func handleRegister(){
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text, let name = self.nameTextField.text else{
            SimpleAlert.showAlert(vc: self, title: "Error", message: "Form is not valid")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                SimpleAlert.showAlert(vc: self, title: "Error", message: "\(error!)")
                return
            }
            guard let uid = user?.uid else{
                return
            }
            
            let userReference = self.databaseReference.child("users").child(uid)
            let values = ["name":name, "email":email, "profileImage":"fb-art"]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    SimpleAlert.showAlert(vc: self, title: "Error", message: err! as! String)
                    return
                }
                self.becomeFirstResponder()
                SimpleAlert.showAlert(vc: self, title: "Sucesso", message: "Você foi registrado com sucesso!")
                self.clearTextFields()
                self.goToLogin()
            })
        })
    }
    
    func clearTextFields() {
        let textFields = [self.emailTextField, self.nameTextField, self.passwordTextField]
        for txtField in textFields{
            txtField?.text?.removeAll()
        }
    }
    
    // MARK : - View Actions
    @IBAction func goToLogin() {
        let parent : LoginPageController = self.parent as! LoginPageController
        parent.setFirstView()
    }
    
    @IBAction func tryToRegister(_ sender: UIButton) {
        self.handleRegister()
    }
    
    // MARK : - Methods Overrided of TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            self.nameTextField.becomeFirstResponder()
        case self.nameTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.passwordTextField.resignFirstResponder()
            self.handleRegister()
        default:
            SimpleAlert.showAlert(vc: self, title: "Error", message: "Error TextField should return method")
        }
        return true
    }
}



















