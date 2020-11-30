//
//  RegisterViewController.swift
//  Booking
//
//  Created by Max Mendes on 06/10/20.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseDatabase
import CryptoKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var loaderScreen: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setTextFields(){
        self.nameTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderWidth = 1
        self.passwordConfirmationTextField.layer.borderWidth = 1
        
        self.nameTextField.layer.cornerRadius = 15
        self.emailTextField.layer.cornerRadius = 15
        self.passwordTextField.layer.cornerRadius = 15
        self.passwordConfirmationTextField.layer.cornerRadius = 15
        
        self.nameTextField.layer.borderColor = UIColor.white.cgColor
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordConfirmationTextField.layer.borderColor = UIColor.white.cgColor
        
        self.nameTextField.layer.masksToBounds = true
        self.emailTextField.layer.masksToBounds = true
        self.passwordTextField.layer.masksToBounds = true
        self.passwordConfirmationTextField.layer.masksToBounds = true

    }
    
    @IBAction func signUp(_ sender: Any) {
        print("Click ok")
        self.view.endEditing(true)
        if let name = self.nameTextField.text {
            if let email = self.emailTextField.text {
                if let password = self.passwordTextField.text {
                    if let passwordConfirmation = self.passwordConfirmationTextField.text {
                        
                        if password == passwordConfirmation {
                            print("Passwords are equal!")
                            let auth = Auth.auth()
                            let databaseReference = Database.database().reference()
                            
                            self.loaderScreen.isHidden = false
                            
                            auth.createUser(withEmail: email, password: password) { (result, error) in
                               
                                let userId = email.data(using: .utf8)
                                
                                if error == nil {
                                    if let result = result {
                                        databaseReference.child("users").child(result.user.uid).setValue(["username": name, "email": email]) { (error, databaseRef) in
                                            
                                            if error == nil{
                                                self.loaderScreen.isHidden = true
                                                self.dismiss(animated: true, completion: nil)
                                            }else {
                                                self.loaderScreen.isHidden = true
                                                self.errorAlert(title: "Erro ao criar perfil", message: "Ocorreu um erro ao criar seu perfil, mas você pode fazer o login no app!")
                                            }
                                        }
                                    }
                                }else{
                                    print(error)
                                    self.loaderScreen.isHidden = true
                                    self.errorAlert(title: "Erro ao cadastrar", message: "Ocorreu um erro efetuar seu cadastro no app! Tente novamente, mais tarde")
                                }
                            }
                            
                        }else{
                            print("Passwords are diferent!")
                            self.errorAlert(title: "Confirmação de senha", message: "As senhas digitadas são diferentes")
                        }
                    }
                }
            }
        }
    }
    
    func errorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}
