//
//  PublicMethodsMode.swift
//  Dice
//
//  Created by Fangchen Li on 1/1/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift


class publicMethod{
    func processAttributedString(input: String, fontsize: CGFloat = 28, numberOfWords: Int = 1) -> NSMutableAttributedString{
        let lightFont = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Light", size: fontsize)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        let boldFont = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: fontsize)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        var words = input.components(separatedBy: " ")
        let lastWord = words.last!
        words.removeLast()
        
        let output = NSMutableAttributedString(string: "\(words.joined(separator: " ")) ".uppercased(), attributes: lightFont)
        output.append(NSMutableAttributedString(string: lastWord.uppercased(), attributes: boldFont))
        return output
    }
    func getTimestamp() -> Int{
        return Int(NSDate().timeIntervalSince1970)
    }
    
    func getShortTimeWord(input: String, shortVersion: Bool) -> String{
        if shortVersion{
            switch(input){
            case "years": return "yr"
            case "year": return "yrs"
            case "month": return "mo"
            case "months": return "mos"
            case "week": return "w"
            case "weeks": return "w"
            case "day": return "d"
            case "days": return "d"
            case "hour": return "hr"
            case "hours": return "hrs"
            case "minute": return "m"
            case "minutes": return "m"
            case "seconds": return "s"
            case "second": return "s"
            default: return " " + input
            }
            
        }   else {
            return " " + input
        }
    }
    
    //Time Ago
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool, shortVersion: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        if (components.year! >= 2) {
            return "\(components.year!)\(self.getShortTimeWord(input: "years", shortVersion: shortVersion)) ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1\(self.getShortTimeWord(input: "year", shortVersion: shortVersion)) ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)\(self.getShortTimeWord(input: "months", shortVersion: shortVersion)) ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1\(self.getShortTimeWord(input: "month", shortVersion: shortVersion)) ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)\(self.getShortTimeWord(input: "weeks", shortVersion: shortVersion)) ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1\(self.getShortTimeWord(input: "week", shortVersion: shortVersion)) ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)\(self.getShortTimeWord(input: "days", shortVersion: shortVersion)) ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1\(self.getShortTimeWord(input: "day", shortVersion: shortVersion)) ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)\(self.getShortTimeWord(input: "hours", shortVersion: shortVersion)) ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1\(self.getShortTimeWord(input: "hour", shortVersion: shortVersion)) ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)\(self.getShortTimeWord(input: "minutes", shortVersion: shortVersion)) ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1\(self.getShortTimeWord(input: "minute", shortVersion: shortVersion)) ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)\(self.getShortTimeWord(input: "seconds", shortVersion: shortVersion)) ago"
        } else {
            return "Just now".localized()
        }
        
    }
}
