//
//  ViewController.swift
//  Booking
//
//  Created by Max Mendes on 06/10/20.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var loaderScreen: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
    }
    
    @IBAction func login(_ sender: Any) {
        
        self.loaderScreen.isHidden = false
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        var tabBar = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        
        let auth = Auth.auth()
        
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                auth.signIn(withEmail: email, password: password) { (result, error) in
                    
                    if error == nil {
                        let userId = result!.user.uid
                        UserDefaults.standard.set(userId, forKey: "userId")
                        self.loaderScreen.isHidden = true
                        window.rootViewController = tabBar
                        
                        UIView.transition(with: window, duration: 0.9, options: .transitionFlipFromRight, animations: {}, completion: nil)
                        
                    }else{
                        self.loaderScreen.isHidden = true
                        self.errorAlert(title: "Usuário ou senha inválido.", message: "Ocorreu um erro ao efetuar login")
                    }
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func errorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setTextFields(){
        self.emailTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderWidth = 1
    
        self.emailTextField.layer.cornerRadius = 15
        self.passwordTextField.layer.cornerRadius = 15
        
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor

        
        self.emailTextField.layer.masksToBounds = true
        self.passwordTextField.layer.masksToBounds = true
        
    }
}


