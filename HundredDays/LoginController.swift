//
//  ViewController.swift
//  HundredDays
//
//  Created by Vinicius Nadin on 06/04/17.
//  Copyright © 2017 Vinicius Nadin. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    // MARK : - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK : - Properties
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK : - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        self.setupLoginButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - View Methods
    func setupTextFields() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.keyboardType = .emailAddress
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.autocorrectionType = .no
    }
    
    func setupLoginButton(){
        self.loginButton.layer.cornerRadius = 5
    }
    
    func verifyField(textField : UITextField) -> Bool{
        var fieldValue = textField.text
        if !(fieldValue?.isEmpty)! {
            if textField == self.emailTextField {
                fieldValue = fieldValue?.replacingOccurrences(of: " ", with: "")
            }
            return true
        }
        SimpleAlert.showAlert(vc: self, title: "Erro", message: "Por favor preencha os campos vazios")
        return false
    }
    
    // MARK : - View Actions
    @IBAction func tryToLogin(_ sender: UIButton) {
        if self.verifyField(textField: self.emailTextField) && self.verifyField(textField: self.passwordTextField){
            let email = self.emailTextField.text
            let password = self.passwordTextField.text
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                        var message = ""
                        switch errCode{
                        case .errorCodeInvalidEmail:
                            message = "Por favor inserir um endereco de email valido!"
                        case .errorCodeUserNotFound:
                            message = "Usuario nao encontrado!!"
                        case .errorCodeWrongPassword:
                            message = "Senha incorreta!!"
                        default:
                            message = "\(error!)"
                        }
                        SimpleAlert.showAlert(vc: self, title: "Erro!", message: message)
                    }
                    return
                }
                self.loadHomeController()
            })
        }
    }
    
    @IBAction func goToRegister(_ sender: UIButton) {
        let parent : LoginPageController = self.parent as! LoginPageController
        parent.setSecondView()
    }
    
    
    
    func loadHomeController() {
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "TabBarInitial")
    }

    // MARK : - Overrided Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}





















