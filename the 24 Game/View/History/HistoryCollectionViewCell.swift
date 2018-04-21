//
//  HistoryCollectionViewCell.swift
//  Dice
//
//  Created by Fangchen Li on 1/1/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cellSolution: UILabel!
    
    @IBOutlet weak var card_1: SmallCardUIView!
    @IBOutlet weak var card_2: SmallCardUIView!
    @IBOutlet weak var card_3: SmallCardUIView!
    @IBOutlet weak var card_4: SmallCardUIView!
    @IBOutlet weak var winnerIndicator: UIView!
    
    var cards: [SmallCardUIView] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellView.layer.borderWidth = 0
        self.cards = [self.card_1, self.card_2, self.card_3, self.card_4]
    }
    func setCard(cardToSet: [Card]){
        for (i, card) in cardToSet.enumerated(){
            self.cards[i].setCard(rank: card.rank, suit: card.suit)
        }
    }
    func showSolution(solution: String){
        self.cellSolution.text = solution
        self.cellSolution.isHidden = false
        for c in cards{
            c.isHidden = true
        }
    }
    func hideSolution(){
        for c in cards{
            c.isHidden = false
        }
        self.cellSolution.isHidden = true
    }
}
