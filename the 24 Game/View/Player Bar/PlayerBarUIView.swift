//
//  PlayerBarUIView.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/21/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import UIKit

class PlayerBarUIView: UIView {

    @IBOutlet var playerBarView: UIView!
    @IBOutlet weak var playerBarContainer: UIView!
    @IBOutlet weak var playerBarButton: UIButton!
    @IBOutlet weak var playerDisabledImage: UIImageView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBAction func playerBarPressed(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerPushed"), object: nil, userInfo: ["player":self.playerNumber])
        let player = TFGame.PlayerSystem.getPlayer(number: self.playerNumber)
        if player.currentState == .idle{
            self.setState(state: .pushed)
        }
    }
    @IBOutlet weak var playerButtonBarLeftOffset: NSLayoutConstraint!
    
    var currentState: PlayerBarState = .idle
    var playerNumber: Int = 1

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewDidInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewDidInit()
    }
    func viewDidInit(){
        Bundle.main.loadNibNamed("PlayerBarView", owner: self, options: nil)
        self.addSubview(self.playerBarView)
        self.playerBarView.frame = self.bounds
        self.playerBarView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.otherPlayerPushed(_:)), name: NSNotification.Name(rawValue: "playerPushed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.otherPlayerWrong(_:)), name: NSNotification.Name(rawValue: "otherPlayerWong"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gamePlayerReset), name: NSNotification.Name(rawValue: "gamePlayerReset"), object: nil)
    }
    @objc func otherPlayerPushed(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let otherPlayerNumber = userInfo["player"] as? Int {
                if otherPlayerNumber == self.playerNumber{
                    TFGame.currentGame.gameEnd(winner: self.playerNumber)
                }   else    {
                    let player = TFGame.PlayerSystem.getPlayer(number: self.playerNumber)
                    if player.currentState != .wrong && player.currentState != .notAvalible{
                        self.setState(state: .disabled)
                    }
                    
                }
            }
        }
    }
    @objc func otherPlayerWrong(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let otherPlayerNumber = userInfo["player"] as? Int {
                if otherPlayerNumber == self.playerNumber{
                    self.setState(state: .wrong)
                }   else    {
                    let player = TFGame.PlayerSystem.getPlayer(number: self.playerNumber)
                    if player.currentState != .wrong && player.currentState != .notAvalible{
                        self.setState(state: .idle)
                    }
                    
                }
            }
        }
    }
    @objc func gamePlayerReset(){
        
        self.setState(state: .idle)
        
    }
    func setPlayer(number: Int){
        self.playerNumber = number
        let player = TFGame.PlayerSystem.getPlayer(number: number)
        if player.currentState == .notAvalible{
            self.playerBarView.isHidden = true
        }   else    {
            self.playerBarView.isHidden = false
        }
        
        switch number{
        case 1:
            self.playerImageView.image = #imageLiteral(resourceName: "player_1")
            break
        case 4:
            self.playerImageView.image = #imageLiteral(resourceName: "player_4")
            break
        case 2:
            self.playerImageView.image = #imageLiteral(resourceName: "player_2")
            break
        case 3:
            self.playerImageView.image = #imageLiteral(resourceName: "player_3")
            break
        default:
            self.playerBarView.isHidden = true
            break
        }
    }
    func setState(state: PlayerBarState){
        let player = TFGame.PlayerSystem.getPlayer(number: self.playerNumber)
        switch state{
        case .idle:
            self.playerBarButton.isEnabled = true
            self.playerDisabledImage.isHidden = true
            
            if player.currentState != .idle || self.playerButtonBarLeftOffset.constant > 25 {
                if player.currentState != .notAvalible{
                    player.currentState = .idle
                    self.releaseedAnimation {
                        player.currentState = .idle
                    }
                }
                
            }
            break
            
        case .pushed:
            
            self.playerBarButton.isEnabled = false
            self.playerDisabledImage.isHidden = true
            player.currentState = .pushed
            self.pushedAnimation {
                player.currentState = .pushed
            }
        case .disabled:
            self.playerBarButton.isEnabled = false
            self.playerDisabledImage.isHidden = false
            player.currentState = .disabled
            self.pushedAnimation {
                player.currentState = .disabled
            }
        case .wrong:
            self.playerBarButton.isEnabled = false
            self.playerDisabledImage.isHidden = false
            player.currentState = .wrong
            self.pushedAnimation {
                player.currentState = .wrong
            }
            break
        case .notAvalible:
            break
        case .animating:
            break
        }
    }
    func pushedAnimation(completion: @escaping () -> Void){
        self.playerButtonBarLeftOffset.constant = 100
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
            self.layoutIfNeeded()
            
        }) { (finished) in
            completion()
        }
    }
    func releaseedAnimation(completion: @escaping () -> Void){
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [.curveEaseIn], animations: {
            self.playerButtonBarLeftOffset.constant = 25
            self.layoutIfNeeded()
            
        }) { (finished) in
            completion()
        }
    }

}
