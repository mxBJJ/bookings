//
//  HomeViewController.swift
//  Booking
//
//  Created by Max Mendes on 06/10/20.
//

import UIKit
import ImageSlideshow

class HomeViewController: UIViewController, ImageSlideshowDelegate {

    @IBOutlet weak var slideShow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlideShow()
        setHomeItensBorder()
//        setGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setSlideShow(){
        
        self.slideShow.setImageInputs([
            ImageSource(image: (UIImage(named: "principal") ?? UIImage(named: "logo"))!),
            ImageSource(image: (UIImage(named: "secundaria") ?? UIImage(named: "logo"))!),
            ImageSource(image: (UIImage(named: "simples") ?? UIImage(named: "logo"))!)
        ])
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        self.slideShow.pageIndicator = pageIndicator
        
        self.slideShow.slideshowInterval = 5.0
        self.slideShow.circular = true
        self.slideShow.contentScaleMode = .scaleAspectFill
        self.slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        
        
        self.slideShow.activityIndicator = DefaultActivityIndicator(style: .gray, color: nil)
        self.slideShow.delegate = self

    }
    
    func setHomeItensBorder(){
        
        let item1 = self.view.viewWithTag(100)
        
        item1?.layer.cornerRadius = 8.0
        item1?.layer.shadowColor = UIColor.black.cgColor
        item1?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        item1?.layer.shadowRadius = 6.0
        item1?.layer.shadowOpacity = 0.7
        
        
        
        let item2 = self.view.viewWithTag(101)
        
        item2?.layer.cornerRadius = 8.0
        item2?.layer.shadowColor = UIColor.black.cgColor
        item2?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        item2?.layer.shadowRadius = 6.0
        item2?.layer.shadowOpacity = 0.7
        
        let item3 = self.view.viewWithTag(102)
        
        item3?.layer.cornerRadius = 8.0
        item3?.layer.shadowColor = UIColor.black.cgColor
        item3?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        item3?.layer.shadowRadius = 6.0
        item3?.layer.shadowOpacity = 0.7
        
        
        let item4 = self.view.viewWithTag(103)
        
        item4?.layer.cornerRadius = 8.0
        item4?.layer.shadowColor = UIColor.black.cgColor
        item4?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        item4?.layer.shadowRadius = 6.0
        item4?.layer.shadowOpacity = 0.7
    }
    
        func setGradientBackground() {
            
            let colorBottom =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
            let colorTop = UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
                        
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = self.view.bounds
                    
            self.view.layer.insertSublayer(gradientLayer, at:0)
        }
}
