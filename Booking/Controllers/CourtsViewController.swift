//
//  NewScheduleViewController.swift
//  Booking
//
//  Created by Max Mendes on 07/10/20.
//

import UIKit
import FirebaseDatabase
import Kingfisher

class CourtsViewController: UIViewController {

    var courts: [Court] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCourts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func getCourts(){
        let databaseRef = Database.database().reference()
        
        databaseRef.child("courts").observe(DataEventType.childAdded) { (snapshot) in
            
            let data = snapshot.value as! NSDictionary
            
            let name = data["name"] as! String
            let price = data["price"] as! Double
            let description = data["description"] as! String
            let thumbnailUrl = data["thumbnailUrl"] as! String
            
            var court = Court()
            
            court.name = name
            court.price = price
            court.description = description
            court.thumbnailUrl = thumbnailUrl
            
            self.courts.append(court)
            self.collectionView.reloadData()
        }
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
}

extension CourtsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courtCell", for: indexPath) as! CourtsCollectionViewCell
        
        let price = String(courts[indexPath.row].price)
        let imgUrl = URL(string: courts[indexPath.row].thumbnailUrl)
        
        cell.courtDescriptionLbl.text = courts[indexPath.row].description
        cell.courtNameLbl.text = courts[indexPath.row].name
        cell.priceLbl.text = "\(price)/hora"
        cell.courtImageView.kf.setImage(with: imgUrl)
        
        setCard(cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let timesVC = storyboard?.instantiateViewController(withIdentifier: "calendarVC") as! CalendarViewController
        
        timesVC.courtName = courts[indexPath.row].name
        timesVC.price = String(courts[indexPath.row].price)
        
        self.navigationController?.pushViewController(timesVC, animated: true)
        
    }
}
