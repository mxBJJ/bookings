//
//  MyGamesViewController.swift
//  Booking
//
//  Created by Max Mendes on 13/10/20.
//

import UIKit
import FirebaseDatabase


class MyGamesViewController: UIViewController {

    
    var games: [Game] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyGames()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setCard(cell: UICollectionViewCell){
        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    }
    
    
    func getMyGames(){
        
        let databaseRef = Database.database().reference()
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        databaseRef.child("user-games").child(userId).queryLimited(toFirst: 10).observe(DataEventType.childAdded) { (snapshot) in
            
                    let data = snapshot.value as? NSDictionary
            
                    let  firstSetPlayer1 = data?["firstSetPlayer1"] as! String
                    let secondSetPlayer1 = data?["secondSetPlayer1"] as! String
                    let thirdSetPlayer1 = data?["thirdSetPlayer1"] as! String
                    let  firstSetPlayer2 = data?["firstSetPlayer2"] as! String
                    let secondSetPlayer2 = data?["secondSetPlayer2"] as! String
                    let thirdSetPlayer2 = data?["thirdSetPlayer2"] as! String
                    let username = data?["username"] as! String
                    let player2 = data?["player2"] as! String
            
                    
                    var game = Game()
                    
                    game.firstSetPlayer1 = firstSetPlayer1
                    game.secondSetPlayer1 = secondSetPlayer1
                    game.thirdSetPlayer1 = thirdSetPlayer1
                    
                    game.firstSetPlayer2 = firstSetPlayer2
                    game.secondSetPlayer2 = secondSetPlayer2
                    game.thirdSetPlayer2 = thirdSetPlayer2
            
                    game.username = username
                    game.player2 = player2
            
            
                    self.games.append(game)
                    self.collectionView.reloadData()
            }
        }
}

extension MyGamesViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gamesCell", for: indexPath) as! MyGamesCollectionViewCell
        
        cell.player1Lbl.text = "\(games[indexPath.row].username)"
        cell.player2Lbl.text = "\(games[indexPath.row].player2)"
    
        cell.result1.text = "\(games[indexPath.row].firstSetPlayer1)     \(games[indexPath.row].secondSetPlayer1)     \(games[indexPath.row].thirdSetPlayer1)"
        
        cell.result2.text = "\(games[indexPath.row].firstSetPlayer2)     \(games[indexPath.row].secondSetPlayer2)     \(games[indexPath.row].thirdSetPlayer2)"


        self.setCard(cell: cell)
        
        return cell

    }
    
    
}
