//
//  MyGamesViewController.swift
//  Booking
//
//  Created by Max Mendes on 11/10/20.
//

import UIKit
import FirebaseDatabase

class CreateGameViewController: UIViewController {
        
    @IBOutlet weak var firstSetPlayer1: UITextField!
    
    @IBOutlet weak var secondSetPlayer1: UITextField!
    
    @IBOutlet weak var thirdSetPlayer1: UITextField!
    
    @IBOutlet weak var firstSetPlayer2: UITextField!
    
    @IBOutlet weak var secondSetPlayer2: UITextField!
    
    @IBOutlet weak var thirdSetPlayer2: UITextField!
    
    @IBOutlet weak var player1Name: UITextField!
    
    @IBOutlet weak var player2Name: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUsername()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func setUsername(){
        let databaseRef = Database.database().reference()
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        databaseRef.child("users").child(userId).observe(.value) { (snapshot) in
            
            let data = snapshot.value as? NSDictionary
            let username = data?["username"] as! String
         
            if let player1Name = self.player1Name {
                player1Name.text = username.uppercased()
            }
        }
    }

    @IBAction func saveGame(_ sender: Any) {
        confirmationAlert(title: "Salvar partida", message: "Você realmente deseja salvar esta partida?")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func errorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "ENTENDI", style: .cancel, handler: nil)
        
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    func successAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    

    func confirmationAlert(title: String, message: String){
        let userId = UserDefaults.standard.string(forKey: "userId")!

        let databaseRef = Database.database().reference()

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "CANCELAR", style: .cancel, handler: nil)
        let actionConfirm = UIAlertAction(title: "CONFIRMAR", style: .default) { (action) in

            if let firstSetPlayer1 = self.firstSetPlayer1.text {
                if let secondSetPlayer1 = self.secondSetPlayer1.text {
                    if let thirdSetPlayer1 = self.thirdSetPlayer1.text {
                        if let firstSetPlayer2 = self.firstSetPlayer2.text {
                            if let secondSetPlayer2 = self.secondSetPlayer2.text {
                                if let thirdSetPlayer2 = self.thirdSetPlayer2.text {
                                    if let player1Name = self.player1Name.text {
                                        if let player2Name = self.player2Name.text {

                                            databaseRef.child("games").childByAutoId().setValue(["userId": userId,"firstSetPlayer1": firstSetPlayer1,"secondSetPlayer1": secondSetPlayer1, "thirdSetPlayer1": thirdSetPlayer1,"firstSetPlayer2": firstSetPlayer2,"secondSetPlayer2": secondSetPlayer2, "thirdSetPlayer2": thirdSetPlayer2, "username": player1Name, "player2": player2Name]) {
                                                (error,databaseRef) in

                                                if(error == nil){

                                                    print("Partida salva com sucesso!")
                                                    self.successAlert(title: "Partida salva", message: "Sua partida foi salva com sucesso!")

                                                }else{
                                                    print("Erro ao salvar partida!")
                                                    self.errorAlert(title: "Erro", message: "Ocorreu um erro ao salvar sua partida.Por favor, tente novamente mais tarde.")
                                                }
                                            }

                                            databaseRef.child("user-games").child(userId).childByAutoId().setValue(["userId": userId,"firstSetPlayer1": firstSetPlayer1,"secondSetPlayer1": secondSetPlayer1, "thirdSetPlayer1": thirdSetPlayer1,"firstSetPlayer2": firstSetPlayer2,"secondSetPlayer2": secondSetPlayer2, "thirdSetPlayer2": thirdSetPlayer2, "username": player1Name, "player2": player2Name])
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        alert.addAction(actionConfirm)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}
