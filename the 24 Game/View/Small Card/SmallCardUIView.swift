//
//  SmallCardUIView.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/20/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import UIKit

class SmallCardUIView: UIView {
    
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var cardBGView: UIView!
    @IBOutlet weak var cardRightBGView: UIView!
    @IBOutlet weak var cardLeftBGView: UIView!
    @IBOutlet weak var cardSuitSmall: UIImageView!
    @IBOutlet weak var cardRank: UILabel!

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
            break
        case .Diamond, .Heart:
            self.cardBGView.backgroundColor = UIColor.TFRed
            self.cardLeftBGView.backgroundColor = UIColor.TFRed
            
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
        switch rank{
        case 1:
            self.cardRank.text = "A"
            break
        case 11:
            self.cardRank.text = "J"
            break
        case 12:
            self.cardRank.text = "Q"
            break
        case 13:
            self.cardRank.text = "K"
            break
        default:
            self.cardRank.text = "\(rank)"
            break
        }
        self.setCardBG(suit: suit)
        self.cardSuitSmall.image = UIImage(named: "suit-\(suit.rawValue)-colored")
        
    }
    func viewDidInit(){
        Bundle.main.loadNibNamed("SmallCardView", owner: self, options: nil)
        self.addSubview(self.cardView)
        cardView.frame = self.bounds
        cardView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.cardView.layer.cornerRadius = 4
        self.cardView.clipsToBounds = true
        
    }
}
