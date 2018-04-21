//
//  CardView.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/19/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import UIKit

class CardView: SpringView {
    
    @IBOutlet weak var cardBGView: UIView!
    @IBOutlet weak var cardRightBGView: UIView!
    @IBOutlet weak var cardLeftBGView: UIView!
    @IBOutlet weak var cardBGHoverView: UIView!
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var cardTop: SpringImageView!
    @IBOutlet weak var cardRank: SpringLabel!
    @IBOutlet weak var cardSuitSmall: SpringImageView!
    
    @IBOutlet weak var cardSuit: SpringImageView!
    
    @IBOutlet weak var cardCover_1: SpringImageView!
    
    @IBOutlet weak var cardBack: SpringImageView!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewDidInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewDidInit()
    }
    func setCardBG(suit: CardSuit){
        switch suit {
        case .Clubs, .Spade:
            self.cardBGView.backgroundColor = UIColor.black
            self.cardLeftBGView.backgroundColor = UIColor.TFLightBlack
             self.cardRightBGView.backgroundColor = UIColor.black
            break
        case .Diamond, .Heart:
            self.cardBGView.backgroundColor = UIColor.TFRed
            self.cardLeftBGView.backgroundColor = UIColor.TFRed
            self.cardRightBGView.backgroundColor = UIColor.TFRed
            
        }
    }
    func setCardNumber(rank: Int, suit: Int){
        var realSuit: CardSuit = .Spade
        switch (suit % 4){
        case 0:
            realSuit = .Heart
            break
        case 1:
            realSuit = .Spade
            break
        case 2:
            realSuit = .Diamond
            break
        case 3:
            realSuit = .Clubs
            break
            
        default:
            break
        }
        self.setCard(rank: rank, suit: realSuit)
    }
    func setCard(rank: Int, suit: CardSuit){
        
        self.setCardBG(suit: suit)
        self.cardSuit.image = UIImage(named: "suit-\(suit.rawValue)")
        self.cardSuitSmall.image = UIImage(named: "suit-\(suit.rawValue)-colored")
        switch rank{
        case 1:
            self.cardRank.text = "A"
            break
        case 11:
            self.cardRank.text = "J"
            self.cardSuit.image = UIImage(named: "jack")
            break
        case 12:
            self.cardRank.text = "Q"
            self.cardSuit.image = UIImage(named: "queen")
            break
        case 13:
            self.cardRank.text = "K"
            self.cardSuit.image = UIImage(named: "king")
            break
        default:
            self.cardRank.text = "\(rank)"
            break
        }
    }
    func resetCard(){
        self.cardBack.alpha = 1
        self.cardCover_1.alpha = 1
    }
    func initAnimationSettings(delayLevel: Int = 0){
        let delay: CGFloat = 1.3
        self.cardCover_1.alpha = 1
        self.cardCover_1.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        self.cardCover_1.animation = "zoomOut"
        self.cardCover_1.curve = "easeOut"
        self.cardCover_1.force = 0.005
        self.cardCover_1.duration = 1
        self.cardCover_1.delay = 0.5
        
  
        self.cardBack.animation = "fadeOut"
        self.cardBack.duration = 0.1
        self.cardBack.delay = 0.25 + CGFloat(delayLevel) * 0.1
        
        self.cardSuit.animation = "fadeIn"
        self.cardSuit.curve = "easeIn"
        self.cardSuit.duration = 0.4
        self.cardSuit.rotate = 1
        self.cardSuit.delay = delay - 0.3
        
        self.cardTop.animation = "slideDown"
        self.cardTop.curve = "easeIn"
        self.cardTop.duration = 1
        self.cardTop.delay = delay
        
        self.cardRank.animation = "fadeIn"
        self.cardRank.curve = "easeIn"
        self.cardRank.duration = 1
        self.cardRank.y = 15
        self.cardRank.delay = delay + 0.7
        
        self.cardSuitSmall.animation = "fadeIn"
        self.cardSuitSmall.curve = "easeIn"
        self.cardSuitSmall.duration = 1
        self.cardSuitSmall.y = 15
        self.cardSuitSmall.delay = delay + 0.7
    }
    func startAnimation(completion: @escaping () -> Void){
        
        self.cardCover_1.animate()
        self.cardSuit.animate()
        self.cardTop.animate()
        self.cardRank.animate()
        self.cardSuitSmall.animateNext {
            //                self.cardCover_1.alpha = 0
            
            
        }
        self.cardBack.animateNext {
            completion()
        }
        
        
        
        
        
        

    }
    func viewDidInit(){
        Bundle.main.loadNibNamed("CardUIView", owner: self, options: nil)
        self.addSubview(self.cardView)
        cardView.frame = self.bounds
        cardView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.cardBack.layer.borderColor = UIColor.white.cgColor
        
        self.cardBack.layer.borderWidth = 0
        self.cardView.layer.cornerRadius = 8
        self.cardView.clipsToBounds = true
        
    }
    
}
