//
//  ViewController.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/19/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import UIKit
let gameSolver = Solver()
class CardViewController: UIViewController, FaveButtonDelegate {

    @IBOutlet weak var card_1: CardView!
    @IBOutlet weak var card_2: CardView!
    @IBOutlet weak var card_3: CardView!
    @IBOutlet weak var card_4: CardView!
    
    @IBOutlet weak var player_1: PlayerBarUIView!
    
    @IBOutlet weak var player_2: PlayerBarUIView!
    
    @IBOutlet weak var player_3: PlayerBarUIView!
    
    @IBOutlet weak var player_4: PlayerBarUIView!
    @IBOutlet weak var solutionLabel: UILabel!
    
    
    @IBOutlet weak var lockButton: FaveButton!
    @IBOutlet weak var historyButton: FaveButton!
    @IBOutlet weak var rollButton: FaveButton!
    @IBOutlet weak var settingsButton: FaveButton!
    @IBOutlet weak var infoButton: FaveButton!
    @IBOutlet weak var lockOuterButton: UIButton!
    
    @IBOutlet weak var lockButtonText: UILabel!
    @IBOutlet weak var rollButtonText: UILabel!
    @IBOutlet weak var tabbarHeight: NSLayoutConstraint!
    @IBOutlet weak var rollButtonContainer: UIView!
    @IBOutlet weak var gotWrongButton: UIButton!
    
    @IBOutlet weak var wrongButtonContainer: UIView!
    @IBOutlet weak var wrongButtonBottomBG: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var rollButtonBGHeight: NSLayoutConstraint!
    
    var ifLocked: Bool = false
    var rolling:Bool = false
    let colors = [
        DotColors(first: UIColor(hex: 0x7DC2F4), second: UIColor(hex: 0xE2264D)),
        DotColors(first: UIColor(hex: 0xF8CC61), second: UIColor(hex: 0x9BDFBA)),
        DotColors(first: UIColor(hex: 0xAF90F4), second: UIColor(hex: 0x90D1F9)),
        DotColors(first: UIColor(hex: 0xE9A966), second: UIColor(hex: 0xF8C852)),
        DotColors(first: UIColor(hex: 0xF68FA7), second: UIColor(hex: 0xF6A2B8))
    ]
    
    
    
    
    var players: [PlayerBarUIView] = []
    var cards:[CardView] = []
    
    @IBAction func gotWrong(_ sender: Any) {
        
        if TFGame.currentGame.winner != 0{
            TFGame.PlayerSystem.getPlayer(number: TFGame.currentGame.winner).currentState = .wrong
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "otherPlayerWong"), object: nil, userInfo: ["player": TFGame.currentGame.winner])
            
            TFGame.currentGame.winner = 0
            self.wrongButtonContainer.isHidden = true
        }
        var totalWrong = 0
        for player in TFGame.PlayerSystem.players{
            if player.currentState == .wrong{
                totalWrong += 1
            }
        }
        
        if totalWrong == TFGame.PlayerSystem.numberOfPlayers{
            self.showAnswer()
        }
    }
    func showAnswer(){
        if self.solutionLabel.text != "Solution"{
            if self.solutionLabel.isHidden{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerPushed"), object: nil, userInfo: ["player": 0])
                self.lockButton.isSelected = true
                self.lockButtonText.textColor = UIColor.seraphOrange
            }   else    {
                self.lockButton.isSelected = false
                self.lockButtonText.textColor = UIColor.TFButtonText
            }
            
            self.solutionLabel.isHidden = !self.solutionLabel.isHidden
        }   else    {
            self.lockButton.isSelected = false
            self.lockButtonText.textColor = UIColor.TFButtonText
        }
    }
    @IBAction func SettingsOuterButtonPressed(_ sender: Any) {
        self.settingsButton.sendActions(for: .touchUpInside)
    }
    @IBAction func LockOuterButtonPressed(_ sender: Any) {
        self.lockButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func InfoOuterButtonPressed(_ sender: Any) {
        self.infoButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func HistoryOuterButtonPressed(_ sender: Any) {
        self.historyButton.sendActions(for: .touchUpInside)
    }
    @IBAction func RollOuterButtonPressed(_ sender: Any) {
        self.rollButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func clickRollButton(_ sender: Any) {
        TFGame.newGame()
        for (i, player) in self.players.enumerated(){
            player.setPlayer(number: i + 1)
        }
        TFGame.RecordSystem.newRoll()
        self.lockOuterButton.isEnabled = true
        self.playerView.isHidden = false
        self.sendCards()
        self.solutionLabel.isHidden = true
        self.lockButton.isSelected = false
        self.lockButtonText.textColor = UIColor.TFButtonText
        self.rollButton.isEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gamePlayerReset"), object: nil)
        self.wrongButtonContainer.isHidden = true
    }
    @IBAction func clickSettingsButton(_ sender: Any) {
        performSegue(withIdentifier: "jumpToLevelSelect", sender: nil)
    }
    
    @IBAction func clickHistoryButton(_ sender: Any) {
        performSegue(withIdentifier: "jumpToHistory", sender: nil)
    }
    
    @IBAction func clickLockButton(_ sender: Any) {
        self.showAnswer()
        
    }
    @IBAction func clickInfoButton(_ sender: Any) {
        performSegue(withIdentifier: "jumpToInfo", sender: nil)
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
        
        
        switch faveButton{
        case self.lockButton:
            if selected{
                self.lockButtonText.textColor = UIColor.seraphOrange
            }   else    {
                self.lockButtonText.textColor = UIColor.TFButtonText
            }
            if self.solutionLabel.isHidden{
                faveButton.isSelected = false
//                self.lockButtonText.textColor = UIColor.TFButtonText
                
            }   else    {
                faveButton.isSelected = true
//                self.lockButtonText.textColor = UIColor.seraphOrange

            }
            
            break
        case self.historyButton:
            faveButton.isSelected = false
            break
        case self.settingsButton:
            faveButton.isSelected = false
            break
        case self.infoButton:
            faveButton.isSelected = false
            break
        case self.rollButton:
            faveButton.isSelected = false
            break
        default:
            break
        }
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        return colors
    }
    
    func enableReRollButton(){
        self.rollButton.isEnabled = true
        self.rollButton.isSelected = false
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
        }
    }
    
    func resetAllCards(){
        
        
        for (i,card) in cards.enumerated(){
            if let cd = TFGame.getCurentGameCard(at: (i + 1)){
                card.setCard(rank: cd.rank, suit: cd.suit)
            }
            card.resetCard()
        }
        
    }
    func sendCards(){
        
        self.resetAllCards()
        
        self.solutionLabel.text = TFGame.getCurrentSolution()[0]
        let delay:CGFloat = 0.1
        let duration: CGFloat = 1.2
        var when = DispatchTime.now()
        for (i, card) in cards.enumerated(){
            card.animation = "slideUp"
            card.curve = "easeIn"
            card.duration = duration
            card.damping = 1
            
            card.force = 3
            card.scaleX = 1
            card.scaleY = 1
            card.delay = delay * CGFloat(i)
            
            if i == 0 || i == 2{
                card.x = 100
                card.rotate = 0.4
            }   else    {
                card.x = -100
                card.rotate = -0.4
            }
            when = when + Double(delay)
            DispatchQueue.main.asyncAfter(deadline: when) {
                if #available(iOS 10.0, *) {
                    if !TFGame.settings.notUseTaptic{
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    
                
                } else {
                    // Fallback on earlier versions
                }
            }
            card.animateNext {
                card.animation = "flipX"
                card.force = 0
                card.x = 0
                card.y = 0
                card.curve = "linear"
                card.duration = 0.5
                card.animateTo()
                
                card.initAnimationSettings(delayLevel: i)
                card.startAnimation(completion: {
                    if i == 3{
                        TFGame.currentGame.gameStart()
                        
                    }
                })
                self.enableReRollButton()
            }
            
            
        }
       
        
        
    }
    @objc func playerPushed(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let otherPlayerNumber = userInfo["player"] as? Int {
                if otherPlayerNumber == 0{
                    
                }   else    {
                    switch TFGame.currentGame.winner{
                    case 1:
                        self.wrongButtonContainer.backgroundColor = UIColor.TFRed
                        self.wrongButtonBottomBG.backgroundColor = UIColor.TFBlackHover
                        break
                    case 2:
                        self.wrongButtonContainer.backgroundColor = UIColor.TFLightBlack
                        self.wrongButtonBottomBG.backgroundColor = UIColor.black
                        break
                    case 3:
                        self.wrongButtonContainer.backgroundColor = UIColor.seraphOrange
                        self.wrongButtonBottomBG.backgroundColor = UIColor.TFBlackHover
                        break
                    case 4:
                        self.wrongButtonContainer.backgroundColor = UIColor.seraphDarkBlue
                        self.wrongButtonBottomBG.backgroundColor = UIColor.TFBlackHover
                        break
                        
                    default:
                        break
                    }
                    self.wrongButtonContainer.isHidden = false
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cards = [self.card_1, self.card_2, self.card_3, self.card_4]
        self.players = [self.player_1, self.player_2, self.player_3, self.player_4]
        
        self.player_4.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.player_2.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        for (i,player) in self.players.enumerated(){
            player.setPlayer(number: i + 1)
        }
//        let solutions = gameSolver.solve(ns: [13,2,9,9])
//        for solution in solutions{
//            let result = gameSolver.render(solution: solution)
//            print(result)
//        }
        self.wrongButtonContainer.layer.cornerRadius = 8
        self.wrongButtonContainer.clipsToBounds = true
        self.wrongButtonContainer.isHidden = true
        for card in cards{
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.4
            card.layer.shadowOffset = CGSize.zero
            card.layer.shadowRadius = 2
        }
        
        
        
        self.lockOuterButton.isEnabled = false
        self.rollButtonContainer.layer.cornerRadius = self.rollButtonContainer.frame.width / 2
        self.rollButtonContainer.clipsToBounds = true
        
        if !UIDevice().isPlus {
            
            self.rollButtonBGHeight.constant = 75
        }
        
        self.tabbarHeight.constant = CGFloat(TFGame.UIElements["tabbarHeight"]!)
    
        self.lockButton.setBackgroundImage(UIImage(named: "Icon-solution"), for: .normal)
        self.lockButton.setBackgroundImage(UIImage(named: "Icon-solution-selected"), for: .selected)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerPushed(_:)), name: NSNotification.Name(rawValue: "playerPushed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.menuDidConfig), name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil)
       
    }
    @objc func menuDidConfig(){
        for (i, player) in self.players.enumerated(){
            player.setPlayer(number: i + 1)
        }
        self.rollButton.sendActions(for: .touchUpInside)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

