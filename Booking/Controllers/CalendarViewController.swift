//
//  CalendarViewController.swift
//  Booking
//
//  Created by Max Mendes on 08/10/20.
//

import UIKit
import FSCalendar
import FirebaseDatabase

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var loaderScreen: UIView!
    
    var day: String?
    var time: String?
    var client: String = ""
    var price: String = ""
    var courtName: String = ""
    
    var busyTimes: [String] = []
    var busyIndexPaths: [Int] = []
    
    let times: [String] = ["8:00","10:00","13:00","15:00","17:00","19:00","21:00","23:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        let today = formatter.string(from:  Date())
        self.day = today
        
        getTimes(selectedDate: today)
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
    
    func getTimes(selectedDate: String){
        let databaseRef = Database.database().reference()
        self.busyTimes.removeAll()
        self.loaderScreen.isHidden = false
        if self.day != nil {
            databaseRef.child("bookings").observe(DataEventType.childAdded) { (snapshot) in
                
                let data = snapshot.value as? NSDictionary
                
                let day = data?["day"] as! String
                let time = data?["time"] as! String
                                
                if day == selectedDate {
                    self.busyTimes.append(time)
                    print(self.busyTimes)
                    self.collectionView.reloadData()
                }
                self.loaderScreen.isHidden = true
            }
            
            if time == nil{
                self.loaderScreen.isHidden = true
            }
        }
    }
    
    
    func confirmationAlert(title: String, message: String){
        let userId = UserDefaults.standard.string(forKey: "userId")!

        let databaseRef = Database.database().reference()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "CANCELAR", style: .cancel, handler: nil)
        let actionConfirm = UIAlertAction(title: "CONFIRMAR", style: .default) { (action) in
            self.loaderScreen.isHidden = false
            
            databaseRef.child("bookings").childByAutoId().setValue(["userId": userId,"day": self.day ,"time": self.time, "name": self.courtName, "price": self.price]) {
                (error,databaseRef) in
                
                if(error == nil){
                    
                    self.loaderScreen.isHidden = true
                    print("Reserva efetuada com sucesso!")
                    self.successAlert(title: "Reserva confirmada", message: "Sua reserva foi efetuada com sucesso!")
                    
                }else{
                    self.loaderScreen.isHidden = true
                    self.errorAlert(title: "Erro ao reservar", message: "Ocorreu um erro ao efetuar sua reserva. Tente novamente, mais tarde!")
                }
            }
            
            databaseRef.child("user-bookings").child(userId).childByAutoId().setValue(["day": self.day ,"time": self.time, "name": self.courtName, "price": self.price])
            
        }
        alert.addAction(actionConfirm)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.collectionView.reloadData()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        let myDate = formatter.string(from: date)

        print(myDate)
        self.day = myDate
        getTimes(selectedDate: myDate)
    }
}

extension CalendarViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timesCell", for: indexPath) as! TimesCollectionViewCell
        
        cell.timeLbl.text = self.times[indexPath.row]
        cell.timeBtn.layer.cornerRadius = 8.0
        
        
        if busyTimes.contains(where: {$0 == cell.timeLbl.text}) {
            cell.timeBtn.backgroundColor = UIColor(red: 187.0/255.0, green: 255.0/255.0, blue: 187.0/255.0, alpha: 1)
            cell.isUserInteractionEnabled = false
        }else{
            cell.timeBtn.backgroundColor = UIColor(red: 68.0/255.0, green: 152.0/255.0, blue: 93.0/255.0, alpha: 1)
            cell.isUserInteractionEnabled = true
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: size)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timesCell", for: indexPath) as! TimesCollectionViewCell
        
            if(self.day != nil){
                self.time = times[indexPath.row]
                self.confirmationAlert(title: "Confirmar reserva", message: "Você deseja reservar a quadra para o dia \(self.day!) às \(self.time!)")
            }else{
                self.errorAlert(title: "Ops!", message: "Selecione um dia antes de escolher o horário da sua reserva.")
        }
    }
}
