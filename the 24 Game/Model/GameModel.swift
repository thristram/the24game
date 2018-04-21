//
//  GameModel.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/20/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit

enum PlayerBarState: Int{
    case pushed
    case disabled
    case idle
    case notAvalible
    case animating
    case wrong
}
class Players{
    var numberOfPlayers: Int = 2
    var acceptedPlaysers: [Int] = [1,2,3,4]
    var players: [Player] = [Player(number: 1),Player(number: 2), Player(number: 3), Player(number: 4)]
    
    init(){
        self.setPlayers(numbers: 2)
    }
    func setPlayers(numbers: Int){
        self.numberOfPlayers = numbers
        for (i, player) in self.players.enumerated(){
            if i < numbers{
                player.currentState = .idle
            }   else    {
                player.currentState = .notAvalible
            }
            
        }
    }
    func getPlayer(number: Int) -> Player{
        if number < 5 && number > 0{
            return self.players[number - 1]
        }   else    {
            return self.players[0]
        }
    }
}
class Player{
    var number:Int
    var currentState: PlayerBarState = .idle
    init(number: Int){
        self.number = number
    }
}
class Record{
    var games:[Int: SingleGame] = [:]
    var recordStarting: Int = 0
    var numberOfRolls: Int = 0
    
    init(){
        self.numberOfRolls = UserDefaults.standard.integer(forKey: "numberOfRolls")
    }
    func newRoll(){
        self.numberOfRolls += 1
        UserDefaults.standard.set(self.numberOfRolls, forKey: "numberOfRolls")
    }
    func writeRecord(game: SingleGame){
        self.games[game.initTime] = game
    }
    func getRecordList() -> [Int]{
        var fetchedResult:[Int] = []
        for (name, game) in self.games{
            if game.timestamp != 0{
                if game.initTime >= self.recordStarting{
                    fetchedResult.append(name)
                }
                
            }
            
        }
        return fetchedResult.sorted{ $0 > $1 }
    }
    func getRecord(timestamp: Int) -> SingleGame?{
        return self.games[timestamp]
    }
    func setRecordStarting(){
        self.recordStarting = PublicMethods.getTimestamp()
    }
    func getStatistics(from: Int? = nil) -> [Int: Int]{
        var realFrom = self.recordStarting
        if from != nil{
            realFrom = from!
        }
        var statistics: [Int: Int] = [1:0, 2:0, 3:0, 4:0]
        for (_,game) in self.games{
            if game.winner != 0{
                if game.initTime >= realFrom{
                    statistics[game.winner] = statistics[game.winner]! + 1
                }
                
            }
        }
        return statistics
    }
}
class MobileDevice {
    var UUID: String = UIDevice.current.identifierForVendor!.uuidString
    var APNSToken: String = ""
    var name: String = UIDevice.current.name
    
    func setAPNSToken(token: String){
        print("APNS Token is \(token)")
        self.APNSToken = token
        SSP.reportDeviceIdentity()
        
    }
    func failToGetAPNS(){
        SSP.reportDeviceIdentity()
    }
}
class SingleGame{
    var cards: [Card] = []
    var initTime: Int = 0
    var timestamp: Int = 0
    var duration: Int = 0
    var winner: Int = 0
    init(){
        
    }
    init(hash: String){
        let tempCardHash = hash.split(separator: ",")
        for cardHash in tempCardHash{
            let card = Card(hash: String(cardHash))
            self.cards.append(card)
        }
    }
    func gameInit(){
        self.initTime = Int(Date().timeIntervalSince1970)
        TFGame.RecordSystem.writeRecord(game: self)
    }
    func gameStart(){
        self.timestamp = Int(Date().timeIntervalSince1970 * 100)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishRolling"), object: nil, userInfo: [:])
    }
    func gameEnd(winner: Int = 0){
        self.duration = Int(Date().timeIntervalSince1970) - self.timestamp
        if winner == 0 && self.winner != 0 {
            
        }   else    {
            self.winner = winner
        }
        
        if self.cards.count == 4{
            if self.timestamp != 0{
                TFGame.RecordSystem.writeRecord(game: self)
            }
            
        }
        
    }
    func getCard(at: Int) -> Card?{
        if self.cards.count >= at{
            return self.cards[at - 1]
        }
        return nil
    }
    func getSolution() -> [String]{
        var rankArr: [Int] = []
        for card in cards{
            rankArr.append(card.rank)
        }
        let solutions = TFGame.solver.solve(ns: rankArr)
        var parsedSolution: [String] = []
        for solution in solutions{
            parsedSolution.append(TFGame.solver.render(solution: solution))
        }
        return parsedSolution
    }
    var hash: String{
        var tempHash: [String] = []
        for card in self.cards{
            tempHash.append(card.hash)
        }
        return tempHash.joined(separator: ",")
    }
    var record: [String: String]{
        return [
            "ts"    : "\(self.timestamp)",
            "dr"    : "\(self.duration)",
            "win"   : "\(self.winner)",
            "game"  : self.hash
        ]
    }
}
class the24Game{
    var currentGame: SingleGame = SingleGame()
    var UIElements: [String: CGFloat] = [:]
    var solver: Solver = Solver()
    var RecordSystem: Record = Record()
    var PlayerSystem: Players = Players()
    var mobileDevice = MobileDevice()
    
    init(){
        self.initUI()
    }
    func getCurentGameCard(at: Int) -> Card?{
        return self.currentGame.getCard(at: at)
    }
    func getCurrentSolution() -> [String]{
        return self.currentGame.getSolution()
    }
    func newGame(){
        
        self.currentGame.gameEnd()
        self.currentGame = SingleGame()
        self.reGenerateCards()
        self.currentGame.gameInit()
    }
    func generateCard(){
        
        if self.currentGame.cards.count < 4{
            var cardHash: [String] = []
            for card in self.currentGame.cards{
                cardHash.append(card.hash)
            }
            let newCard = Card()
            if cardHash.contains(newCard.hash){
                self.generateCard()
            }   else    {
                self.currentGame.cards.append(newCard)
                self.generateCard()
            }
        }
        if self.currentGame.cards.count == 4{
            if self.getCurrentSolution().count == 0{
                self.reGenerateCards()
            }
        }
    }
    func reGenerateCards(){
        self.clearCards()
        self.generateCard()
    }
    func clearCards(){
        self.currentGame.cards = []
    }
    func initUI(){
        self.UIElements["statusBarHeight"] = 70
        self.UIElements["menuBottomHeight"] = 10
        self.UIElements["storePargerBarTop"] = 54
        self.UIElements["tabbarHeight"] = 90
        self.UIElements["webviewOffset"] = -20
        
        switch UIDevice().screenSize{
        case .iPhonePlus:
            self.UIElements["storePriceButtonTitleOffset"] = -80
            break
        case .iPhoneX:
            self.UIElements["storePriceButtonTitleOffset"] = -80
            self.UIElements["statusBarHeight"] = 100
            self.UIElements["menuBottomHeight"] = 25
            self.UIElements["storePargerBarTop"] = 84
            self.UIElements["tabbarHeight"] = 90 + 34
            self.UIElements["webviewOffset"] = -44
            break
        default:
            break
        }
    }
}
