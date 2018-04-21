//
//  StringExtensions.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/19/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import Foundation
extension String {
    var expression: NSExpression {
        return NSExpression(format: self)
    }
    func indexDistance(of: String, from: Int = 0) -> Int? {
        let indexes = self.indexes(of: of)
        if indexes.count == 0{
            return nil
        }
        for index in indexes{
            let dist = distance(from: self.index(self.startIndex, offsetBy: from), to: index)
            if dist >= 0{
                return distance(from: startIndex, to: index)
            }
        }
        return nil
//        return distance(from: startIndex, to: index)
    }
    func lastIndexDistance(of: String, from: Int? = nil) -> Int? {
        var realFrom = self.count - 1
        if from != nil{
            realFrom = from!
            if from! > (self.count - 1){
                realFrom = self.count - 1
            }
        }
        let indexes = self.indexes(of: of)
        if indexes.count == 0{
            return nil
        }
        for index in indexes.reversed(){
            let dist = distance(from: index, to: self.index(self.startIndex, offsetBy: realFrom))
            if dist >= 0{
                return distance(from: startIndex, to: index)
            }
        }
        return nil
        //        return distance(from: startIndex, to: index)
    }
    func indexDistanceJS(of: String, from: Int = 0) -> Int {
        let indexes = self.indexes(of: of)
        if indexes.count == 0{
            return -1
        }
        for index in indexes{
            let dist = distance(from: self.index(self.startIndex, offsetBy: from), to: index)
            if dist >= 0{
                return distance(from: startIndex, to: index)
            }
        }
        return -1
        //        return distance(from: startIndex, to: index)
    }
    func lastIndexDistanceJS(of: String, from: Int? = nil) -> Int {
        var realFrom = self.count - 1
        if from != nil{
            realFrom = from!
            if from! > (self.count - 1){
                realFrom = self.count - 1
            }
        }
        let indexes = self.indexes(of: of)
        if indexes.count == 0{
            return -1
        }
        for index in indexes.reversed(){
            let dist = distance(from: index, to: self.index(self.startIndex, offsetBy: realFrom))
            if dist >= 0{
                return distance(from: startIndex, to: index)
            }
        }
        return -1
        //        return distance(from: startIndex, to: index)
    }
    func substring(start: Int, end: Int? = nil) -> String{
        var realStart = start
        var realEnd = self.count
        if end != nil{
            if end! < start{
                realStart = end!
                realEnd = start
            }   else    {
                realEnd = end!
            }
        }

        let startIndexes = self.index(self.startIndex, offsetBy: realStart)
        let endIndexes = self.index(self.startIndex, offsetBy: realEnd)
        
        let range = startIndexes..<endIndexes
        
        return String(self[range])
    }

//    func substring(start: Int, length: Int? = nil) -> String{
//
//        let sat = self.index(self.startIndex, offsetBy: start)
//        var end = self.index(self.startIndex, offsetBy: self.count)
//        if length != nil{
//            var offset = start + length! - 1
//            if offset < 1{
//                offset = 0
//            }
////            if offset > self.count{
////                offset = self.count
////            }
//            end = self.index(self.startIndex, offsetBy: offset)
//        }
//
//        let range = sat..<end
//
//        return String(self[range])
//    }
    subscript (i: Int) -> Character {
        
        if i < 0{
            return self[index(startIndex, offsetBy: 0)]
        }
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

//let str = "Hello, playground, playground, playground"
//str.index(of: "play")      // 7
//str.endIndex(of: "play")   // 11
//str.indexes(of: "play")    // [7, 19, 31]
//str.ranges(of: "play")     // [{lowerBound 7, upperBound 11}, {lowerBound 19, upperBound 23}, {lowerBound 31, upperBound 35}]


extension StringProtocol where Index == String.Index {
    func index<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound  ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

