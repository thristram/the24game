//
//  LevelSelectViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/13/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import Firebase

class LevelSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MIBlurPopupDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var newGameButtomBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTrailingInset: NSLayoutConstraint!
    
    @IBOutlet weak var actionViewLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var actionViewTrailingInset: NSLayoutConstraint!
    let reuseIdentifier = "LevelSelectCell"
    var selectedLevel: Int = 2
    var startNewGame: Bool = false
    
    
    var items: [Int] = []
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LevelBackToMenu"), object: nil, userInfo: [:])
        Analytics.logEvent("LevelSelectDismiss", parameters: ["from": "Top Bar Button"])
    }
    @IBAction func newGamePressed(_ sender: Any) {
        if self.startNewGame{
            TFGame.PlayerSystem.setPlayers(numbers: self.selectedLevel)
            Analytics.logEvent("LevelSelectConfirm", parameters: ["levelSelected": self.selectedLevel])
//            TFGame.startNewGame()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissMenu"), object: nil, userInfo: [:])
            })
            TFGame.RecordSystem.setRecordStarting()
            
        }   else    {
            Analytics.logEvent("LevelSelectDismiss", parameters: ["from": "Resume Button"])
            self.dismiss(animated: true, completion: {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissMenu"), object: nil, userInfo: [:])
                
            })
        }
    }
    
    var popupView: UIView {
        return self.collectionView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().isiPad{
            self.collectionViewTrailingInset.constant = (UIScreen.main.bounds.width - 664) / 2
            self.collectionViewLeadingInset.constant = (UIScreen.main.bounds.width - 664) / 2
            self.actionViewTrailingInset.constant = (UIScreen.main.bounds.width - 664) / 2 + 20
            self.actionViewLeadingInset.constant = (UIScreen.main.bounds.width - 664) / 2 + 20
        }
        if UIDevice().screenSize == .iPhone5{
            self.actionViewTrailingInset.constant = 8
            self.actionViewLeadingInset.constant = 8
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView!.register(UINib(nibName: "LevelSelectCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "SettingsHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SettingsHeader")
        self.newGameButton.layer.cornerRadius = 8
        self.newGameButton.backgroundColor = UIColor.mineLoverGrey
        self.newGameButton.clipsToBounds = true
        
        self.items = TFGame.PlayerSystem.acceptedPlaysers
        
        self.selectedLevel = TFGame.PlayerSystem.numberOfPlayers
        self.newGameButtomBottomHeight.constant = CGFloat(TFGame.UIElements["menuBottomHeight"]!) + 25
        self.statusBarHeight.constant = CGFloat(TFGame.UIElements["statusBarHeight"]!)
        self.updateNewGameButton()
        Analytics.logEvent("LevelSelectShown", parameters: nil)
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.bounds.width - 32, height: 68)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return self.items.count
        default:
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if(section == 0){
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
            
        }   else{
            return CGSize(width: UIScreen.main.bounds.width, height: 52)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SettingsHeader", for: indexPath as IndexPath) as! SettingsHeaderCollectionReusableView
        headerView.sectionTitle.text = "Number of Players"
        return headerView
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LevelSelectCollectionViewCell
        let index = indexPath.item
        switch indexPath.section{
        case 0:
            cell.cellView.clipsToBounds = true
            cell.cellView.layer.cornerRadius = 8
            cell.cellView.backgroundColor = UIColor.mineLoverLightBlack
            cell.cellView.layer.borderColor = UIColor.clear.cgColor
            if TFGame.settings.notUseTaptic{
                cell.cellTitle.text = "Use Haptics: OFF"
                cell.cellImage.image = #imageLiteral(resourceName: "Icon-hatpic-off")
            }   else    {
                cell.cellTitle.text = "Use Haptics: ON"
                cell.cellImage.image = #imageLiteral(resourceName: "Icon-hatpic-on")
            }
            return cell
        case 1:
            let level = TFGame.PlayerSystem.acceptedPlaysers
            let cellLevel = level[index]
            if cellLevel == 1{
                cell.cellTitle.text = "\(cellLevel) Player"
            }   else    {
                cell.cellTitle.text = "\(cellLevel) Players"
            }
            
            cell.cellView.clipsToBounds = true
            cell.cellView.layer.cornerRadius = 8
            cell.cellView.backgroundColor = UIColor.mineLoverLightBlack
            
            cell.cellImage.image = #imageLiteral(resourceName: "Icon-cards")
            if self.selectedLevel == cellLevel{
                cell.cellView.layer.borderColor = UIColor.seraphOrange.cgColor
            }   else    {
                cell.cellView.layer.borderColor = UIColor.clear.cgColor
            }
            
            return cell
        default:
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        switch indexPath.section{
        case 0:
            if TFGame.settings.notUseTaptic {
                if #available(iOS 10.0, *) {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                } else {
                    // Fallback on earlier versions
                }
                
            }
            TFGame.settings.setTaptic()
            self.collectionView.reloadData()
            break
        case 1:
            self.selectedLevel = self.items[index]
            self.collectionView.reloadData()
            self.updateNewGameButton()
            break
        default:
            break
        }
        
        
    }
    func updateNewGameButton(){
        if self.selectedLevel != TFGame.PlayerSystem.numberOfPlayers{
            self.newGameButton.setTitle("NEW GAME".localized(), for: .normal)
            self.newGameButton.backgroundColor = UIColor.seraphOrange
            self.startNewGame = true
        }   else    {
            self.newGameButton.setTitle("RESUME".localized(), for: .normal)
            self.newGameButton.backgroundColor = UIColor.mineLoverGrey
            self.startNewGame = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
