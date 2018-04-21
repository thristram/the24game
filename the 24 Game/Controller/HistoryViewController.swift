//
//  LevelSelectViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/13/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MIBlurPopupDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var statisticsCollectionView: UICollectionView!
    
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTrailingInset: NSLayoutConstraint!
    
    
    let reuseIdentifier = "HistoryCell"
    let reuseIdentifierStatistics = "StatisticsCell"
    var selectedRecord: Int = 0
    
    var items: [Int] = []
    
    @IBAction func clearHistory(_ sender: Any) {
        
        self.selectedRecord = 0
        TFGame.RecordSystem.setRecordStarting()
        TFGame.RecordSystem.setRecordStarting()
        self.finishRolling()
        self.statisticsCollectionView.reloadData()
    }
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LevelBackToMenu"), object: nil, userInfo: [:])
        
        Analytics.logEvent("HistoryDismiss", parameters: nil)
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
        }
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.statisticsCollectionView.delegate = self
        self.statisticsCollectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "HistoryCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.statisticsCollectionView!.register(UINib(nibName: "StatisticsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierStatistics)
        self.items = TFGame.RecordSystem.getRecordList()
        self.statusBarHeight.constant = CGFloat(TFGame.UIElements["statusBarHeight"]!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishRolling), name: NSNotification.Name(rawValue: "finishRolling"), object: nil)
        Analytics.logEvent("HistoryShown", parameters: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.items = TFGame.RecordSystem.getRecordList()
        self.collectionView.reloadData()
    }
    @objc func finishRolling(){
        self.items = TFGame.RecordSystem.getRecordList()
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView{
            return CGSize(width: self.collectionView.bounds.width - 32, height: 68)
        }   else    {
            return CGSize(width: (self.collectionView.bounds.width - 16) / CGFloat(TFGame.PlayerSystem.numberOfPlayers) - 12, height: 60)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return self.items.count
        }   else    {
            return TFGame.PlayerSystem.numberOfPlayers
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! HistoryCollectionViewCell
            let index = indexPath.item
            
            
            cell.cellView.clipsToBounds = true
            cell.cellView.layer.cornerRadius = 8
            cell.cellView.backgroundColor = UIColor.mineLoverLightBlack
            
            if let record = TFGame.RecordSystem.getRecord(timestamp: self.items[index]){
                cell.setCard(cardToSet: record.cards)
                
                cell.timeLabel.text = PublicMethods.timeAgoSinceDate(date: NSDate.init(timeIntervalSince1970: TimeInterval(Int(record.timestamp / 100))), numericDates: true, shortVersion: true)
                switch record.winner {
                case 1:
                    cell.winnerIndicator.backgroundColor = UIColor.TFRed
                    break
                case 2:
                    cell.winnerIndicator.backgroundColor = UIColor.black
                    break
                case 3:
                    cell.winnerIndicator.backgroundColor = UIColor.seraphOrange
                    break
                case 4:
                    cell.winnerIndicator.backgroundColor = UIColor.seraphDarkBlue
                    break
                default:
                    
                    cell.winnerIndicator.backgroundColor = UIColor.clear
                    break
                }
                if record.initTime == self.selectedRecord{
                    cell.showSolution(solution: record.getSolution()[0])
                }   else    {
                    cell.hideSolution()
                }
                
            }
            
            
            return cell
        }   else    {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierStatistics, for: indexPath as IndexPath) as! StatisticsCollectionViewCell
            let index = indexPath.item
            let totalPlayer = TFGame.PlayerSystem.numberOfPlayers
            let statistics = TFGame.RecordSystem.getStatistics()
            switch(index){
            case 0:
                cell.setTitle(title: "\(statistics[1]!)")
                cell.setTeam(number: 1)
                break
            case 1:
                if totalPlayer > 1 {
                    cell.setTitle(title: "\(statistics[2]!)")
                    cell.setTeam(number: 2)
                }
                break
            case 2:
                if totalPlayer > 2 {
                    cell.setTitle(title: "\(statistics[3]!)")
                    cell.setTeam(number: 3)
                }
                break
            case 3:
                if totalPlayer > 3 {
                    cell.setTitle(title: "\(statistics[4]!)")
                    cell.setTeam(number: 4)
                }
                break
            default:
                cell.itemBottomBGView.backgroundColor = UIColor.clear
                break
            }
            if index == totalPlayer{
                cell.itemBottomBGView.backgroundColor = UIColor.clear
                cell.itemView.backgroundColor = UIColor.mineLoverLightBlack
                cell.setIcon(icon: #imageLiteral(resourceName: "Icon-redo"))
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView{
            if selectedRecord == self.items[indexPath.row]{
                self.selectedRecord = 0
            }   else    {
                self.selectedRecord = self.items[indexPath.row]
            }
            self.collectionView.reloadData()
        }   else    {
            let index = indexPath.item
            if index == TFGame.PlayerSystem.numberOfPlayers{
                TFGame.RecordSystem.setRecordStarting()
                self.statisticsCollectionView.reloadData()
            }
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

