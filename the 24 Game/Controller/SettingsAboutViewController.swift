//
//  SettingsAboutViewController.swift
//  Seraph
//
//  Created by Fangchen Li on 9/19/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import Firebase

class SettingsAboutViewController: UIViewController,  MIBlurPopupDelegate {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var versionBuildNo: UILabel!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var cheatButton: UIButton!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var allRightsLabel: UILabel!
    var popupView: UIView {
        return self.content
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    var initialScaleAmmount: CGFloat {
        return 0.8
    }
    var animationDuration: TimeInterval {
        return TimeInterval(0.5)
    }
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        self.versionBuildNo.text = "v\(version) Build \(build)"
        self.bottomSpace.constant = CGFloat(TFGame.UIElements["menuBottomHeight"]!) + 10
        self.statusBarHeight.constant = CGFloat(TFGame.UIElements["statusBarHeight"]!)
        Analytics.logEvent("AboutShown", parameters: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.cheatButton.addGestureRecognizer(tapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        self.cheatButton.addGestureRecognizer(longGesture)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeText()
    }
    
    func changeText(){
//        if DiceRoller.cheatMagetitude != nil{
//            switch DiceRoller.cheatMagetitude! {
//            case 1:
//                self.copyrightLabel.text = "Copyright © 2018 Fangchen Li."
//                self.allRightsLabel.text = "All Rights Reserved."
//                return
//            case 2:
//                self.copyrightLabel.text = "Copyright © 2018 Fangchen Li"
//                self.allRightsLabel.text = "All Rights Reserved."
//                return
//            default:
//                break
//            }
//        }
//        self.copyrightLabel.text = "Copyright © 2018 Fangchen Li"
//        self.allRightsLabel.text = "All Rights Reserved"
    }
    
    
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        print("Normal tap")
        
//        if DiceRoller.cheatMagetitude == nil{
//            DiceRoller.cheatMagetitude = 2
//
//        }   else    {
//            DiceRoller.cheatMagetitude = nil
//
//        }
        self.changeText()
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
//        if sender.state == .ended {
//            print("UIGestureRecognizerStateEnded")
//            DiceRoller.cheatMagetitude = 1
//            self.changeText()
//            //Do Whatever You want on End of Gesture
//        }
//        else if sender.state == .began {
//            print("UIGestureRecognizerStateBegan.")
//            //Do Whatever You want on Began of Gesture
//        }
    }
    
    
    
}

