//
//  SchedulesViewController.swift
//  Booking
//
//  Created by Max Mendes on 10/10/20.
//

import UIKit
import FirebaseDatabase
import Lottie

class SchedulesViewController: UIViewController {
    
    @IBOutlet weak var noContentLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var schedules: [Schedule] = []
    let animationView = AnimationView()
    @IBOutlet weak var loadScreen: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getSchedules()
        setupAnimation()
        
    }
    
    func setupAnimation(){
        animationView.animation = Animation.named("ball")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        loadScreen.addSubview(animationView)
    }
    
    func getSchedules(){
        
        loadScreen.isHidden = false
        let databaseRef = Database.database().reference()
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        databaseRef.child("user-bookings").child(userId).queryLimited(toFirst: 10).queryOrdered(byChild: "day").observe(DataEventType.childAdded) { (snapshot) in
            
                    let data = snapshot.value as? NSDictionary
            
                    let courtName = data?["name"] as! String
                    let price = data?["price"] as! String
                    let day = data?["day"] as! String
                    let time = data?["time"] as! String
                    
                    var schedule = Schedule()
                    schedule.court = courtName
                    schedule.price = String(price)
                    schedule.day = day
                    schedule.time = time
                    
                    self.schedules.append(schedule)
                    self.tableView.reloadData()
                    self.loadScreen.isHidden = true
                
            }
        }
    }
    
extension SchedulesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if schedules.count == 0 {
            self.tableView.isHidden = true
            self.noContentLbl.isHidden = false
        }else{
            self.tableView.isHidden = false
            self.noContentLbl.isHidden = true
        }
        
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! SchedulesTableViewCell
        
        cell.courtLbl.text = schedules[indexPath.row].court
        cell.dateLbl.text = schedules[indexPath.row].day
        cell.timeLbl.text = schedules[indexPath.row].time
        
        return cell
    }
}
