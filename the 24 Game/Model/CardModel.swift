//
//  CardModel.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/20/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import Foundation
enum CardSuit: String{
    case Heart = "heart"
    case Spade = "spade"
    case Diamond = "diamond"
    case Clubs = "club"
}
class Card{
    var suit: CardSuit
    var rank: Int
    init(){
        self.rank = Int(arc4random_uniform(13)) + 1
        self.suit = .Clubs
        self.suit = self.translateSuit(suitInt: Int(arc4random_uniform(4)))
    }
    init(hash: String){
        let tempData = hash.split(separator: "-")
        self.rank = Int(String(tempData[0]))!
        switch String(tempData[1]){
        case "heart":
            self.suit = .Heart
            break
        case "spade":
            self.suit = .Spade
            break
        case "diamond":
            self.suit = .Diamond
            break
        case "club":
            self.suit = .Clubs
            break
        default:
            self.suit = .Spade
            break
        }
    }
    func translateSuit(suitInt: Int) ->  CardSuit{
        switch (suitInt % 4){
        case 0:
            return .Heart
        case 1:
            return .Spade
        case 2:
            return .Diamond
        case 3:
            return .Clubs
        default:
            return .Clubs
        }
    }
    init(rank: Int, suit: CardSuit){
        self.rank = rank
        self.suit = suit
    }
    init(rank: Int, suit: Int){
        self.rank = rank
        self.suit = .Clubs
        self.suit = self.translateSuit(suitInt: suit)
    }
    var hash:String {
        return "\(self.rank)-\(self.suit.rawValue)"
    }
    
}
