//
//  SolverModel.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/19/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import Foundation

class Solver{
    let solveExpression = SolverExpression()
    func addToResult(result: [String], expressions: [String], na: Int, nb: Int, nc: Int, nd: Int) -> [String] {
        var solutionResult: [String] = result
        let suffix = "*(\(nc)-\(nd))"
        let solutions = self.solve4(expressions: expressions, na: na, nb: nb)
        for solution in solutions{
            solutionResult.append(solution + suffix)
        }
        return solutionResult
    }
    
    func filter(input: [String], nc: Int, nd: Int) -> [String]{
        let pattern = "(\(nc)-\(nd)"
        var output:[String] = []
        for experssion in input{
            let exp = "(\(experssion)"
            if !(exp.contains("(\(pattern)*")) && !(exp.contains("(\(pattern)*")) && !(exp.contains("/\(pattern)")) {
                output.append(experssion)
            }
        }
        
        return output
    }
    


    
    func solve4(expressions: [String], na: Int? = nil, nb: Int? = nil, nc: Int? = nil, nd: Int? = nil) -> [String] {
        var solutions:[String] = []
        for v in expressions {
            var output = v
            var inputNumber:[String: Double] = [:]
            if na != nil{
                output = output.replacingOccurrences(of: "a", with: "\(na!)")
                inputNumber["a"] = Double(na!)
            }
            if nb != nil{
                output = output.replacingOccurrences(of: "b", with: "\(nb!)")
                inputNumber["b"] = Double(nb!)
            }
            if nc != nil{
                output = output.replacingOccurrences(of: "c", with: "\(nc!)")
                inputNumber["c"] = Double(nc!)
            }
            if nd != nil{
                output = output.replacingOccurrences(of: "d", with: "\(nd!)")
                inputNumber["d"] = Double(nd!)
            }
            if let doubleAvgResult = v.expression.expressionValue(with: inputNumber, context: nil) as? Double {
                let answer = (doubleAvgResult - 24.0).magnitude
                
                if answer < 0.000001{
                    solutions.append(output)
                }
            }
        }
        
        return solutions
    }
    
    func solve(ns: [Int]) -> [String]{
        
        var arr = ns.sorted()
        
        let n0 = arr[0]
        let n1 = arr[1]
        let n2 = arr[2]
        let n3 = arr[3]
        
        if (n0 == n1) {
            if (n1 == n2) {
                if (n2 == n3) {
                    // n0 = n1 = n2 = n3, 3333
                    return self.solve4(expressions: self.solveExpression.EXP_AAAA, na: n0);
                }
                // n0 = n1 = n2 < n3
                if (n0 == 1) {
                    // 111Q
                    return self.solve4(expressions: self.solveExpression.EXP_111A, na: n3);
                }
                if (n0 == 2) {
                    // 2228
                    return self.solve4(expressions: self.solveExpression.EXP_222A, na: n3);
                }
                // 3335
                let result = self.solve4(expressions: self.solveExpression.EXP_AAAB, na: n0, nb: n3);
                if (n3 - n0 == 1) {
                    // 3334
                    return self.addToResult(result: self.filter(input: result, nc: n3, nd: n0), expressions: self.solveExpression.EXP_AA, na: n0, nb: 0, nc: n3, nd: n0);
                }
                return result;
            }
            if (n2 == n3) {
                // n0 = n1 < n2 = n3
                if (n0 == 1) {
                    // 1155
                    return self.solve4(expressions: self.solveExpression.EXP_11AA, na: n2);
                }
                if (n0 == 2) {
                    // 2233
                    return self.solve4(expressions: self.solveExpression.EXP_22AA, na: n2);
                }
                // 3355
                let result = self.solve4(expressions: self.solveExpression.EXP_AABB, na: n2, nb: n0);
                if (n2 - n1 == 1) {
                    // 4455
                    return addToResult(result: self.filter(input: result, nc: n2, nd: n0), expressions: self.solveExpression.EXP_AB, na: n2, nb: n0, nc: n3, nd: n0);
                }
                return result;
            }
            // n0 = n1 < n2 < n3
            if (n0 == 1) {
                // 1145
                return self.solve4(expressions: self.solveExpression.EXP_11AB, na: n3, nb: n2);
            }
            if (n0 == 2) {
                // 2245
                let result = self.solve4(expressions: self.solveExpression.EXP_22AB, na: n3, nb: n2);
                if (n2 == 3) {
                    // 223Q
                    return self.addToResult(result: self.filter(input: result, nc: 3, nd: 2), expressions: self.solveExpression.EXP_AB, na: n3, nb: 2, nc: 3, nd: 2);
                }
                return result;
            }
            // 3356
            let result = self.solve4(expressions: self.solveExpression.EXP_AABC, na: n0, nb: n3, nc: n2);
            if (n2 - n0 == 1) {
                // 3348
                return self.addToResult(result: self.filter(input: result, nc: n2, nd: n0), expressions: self.solveExpression.EXP_AB, na: n3, nb: n0, nc: n2, nd: n0);
            }
            // n3 - n2 == 1 && n0 + n0 == 24 is impossible
            return result;
        }
        if (n1 == n2) {
            if (n2 == n3) {
                // n0 < n1 = n2 = n3
                if (n0 == 1) {
                    // 1888
                    return self.solve4(expressions: self.solveExpression.EXP_1AAA, na: n1);
                }
                // 2333
                return self.solve4(expressions: self.solveExpression.EXP_AAAB, na: n1, nb: n0);
            }
            // n0 < n1 = n2 < n3
            if (n0 == 1) {
                if (n1 == 2) {
                    // 1226
                    return self.solve4(expressions: self.solveExpression.EXP_122A, na: n3);
                }
                // 1334
                return self.solve4(expressions: self.solveExpression.EXP_1AAB, na: n1, nb: n3);
            }
            if (n0 == 2) {
                // 2668
                let result = self.solve4(expressions: self.solveExpression.EXP_2AAB, na: n1, nb: n3);
                if (n1 == 3) {
                    // 2338
                    return self.addToResult(result: self.filter(input: result, nc: 3, nd: 2), expressions: self.solveExpression.EXP_AB, na: n3, nb: 3, nc: 3, nd: 2);
                }
                if (n3 - n1 == 1) {
                    // 2QQK
                    return self.addToResult(result: self.filter(input: result, nc: n3, nd: n1), expressions: self.solveExpression.EXP_AB, na: n1, nb: 2, nc: n3, nd: n1);
                }
                // 2334
                return result
            }
            // 3669
            let result = self.solve4(expressions: self.solveExpression.EXP_AABC, na: n1, nb: n3, nc: n0);
            if (n1 - n0 == 1) {
                // 3446
                return self.addToResult(result: self.filter(input: result, nc: n1, nd: n0), expressions: self.solveExpression.EXP_AB, na: n3, nb: 1, nc: n1, nd: n0);
            }
            if (n3 - n1 == 1) {
                // 4667
                return self.addToResult(result: self.filter(input: result, nc: n3, nd: n1), expressions: self.solveExpression.EXP_AB, na: n1, nb: 0, nc: n3, nd: n1);
            }
            // 5667
            return result
        }
        if (n2 == n3) {
            // n0 < n1 < n2 = n3
            if (n0 == 1) {
                // 1366
                let result = self.solve4(expressions: self.solveExpression.EXP_1AAB, na: n3, nb: n1);
                if (n1 == 2) {
                    // 12QQ
                    return self.addToResult(result: self.filter(input: result, nc: 2, nd: 1),expressions: self.solveExpression.EXP_AA, na: n2, nb: 0, nc: 2, nd: 1);
                }
                return result;
            }
            if (n0 == 2) {
                // 2466
                let result = self.solve4(expressions: self.solveExpression.EXP_2AAB, na: n3, nb: n1);

                if (n1 == 3) {
                    // 23QQ
                    return self.addToResult(result: self.filter(input: result, nc: 3, nd: 2), expressions: self.solveExpression.EXP_AA, na: n2, nb: 0, nc: 3, nd: 2);
                }
                if (n2 - n1 == 1) {
                    // 2JQQ
                    return self.addToResult(result: self.filter(input: result, nc: n2, nd: n1), expressions: self.solveExpression.EXP_AB, na: n2, nb: 2, nc: n2, nd: n1);
                }
                // 2344
                return result
            }
            // 4688
            let result = self.solve4(expressions: self.solveExpression.EXP_AABC, na: n2, nb: n1, nc: n0);
            if (n1 - n0 == 1) {
                // 34QQ
                return self.addToResult(result: self.filter(input: result, nc: n1, nd: n0), expressions: self.solveExpression.EXP_AA, na: n2, nb: 0, nc: n1, nd: n0);
            }
            if (n2 - n1 == 1) {
                // 3788
                return self.addToResult(result: self.filter(input: result, nc: n2, nd: n1), expressions: self.solveExpression.EXP_AB, na: n2, nb: n0, nc: n2, nd: n1);
            }
            // JQKK
            return result
        }
        // n0 < n1 < n2 < n3
        if (n0 == 1) {
            // 1468
            let result = self.solve4(expressions: self.solveExpression.EXP_1ABC, na: n3, nb: n2, nc: n1);
            if (n1 == 2) {
                // 1238
                return addToResult(result: self.filter(input: result, nc: 2, nd: 1), expressions: self.solveExpression.EXP_AB, na: n3, nb: n2, nc: 2, nd: 1);
            }
            return result;
        }
        // 246Q
        let result = self.solve4(expressions: self.solveExpression.EXP_ABCD, na: n3, nb: n2, nc: n1, nd: n0);
        if (n1 - n0 == 1) {
            // 34JK
            return self.addToResult(result: self.filter(input: result, nc: n1, nd: n0), expressions: self.solveExpression.EXP_AB, na: n3, nb: n2, nc: n1, nd: n0);
        }
        if (n2 - n1 == 1) {
            // 3568
            return self.addToResult(result: self.filter(input: result, nc: n2, nd: n1), expressions: self.solveExpression.EXP_AB, na: n3, nb: n0, nc: n2, nd: n1);
        }
        if (n3 - n2 == 1) {
            // 46910
            return self.addToResult(result: self.filter(input: result, nc: n3, nd: n2), expressions: self.solveExpression.EXP_AB, na: n1, nb: n0, nc: n3, nd: n2);
        }
        // 3458,38910,2378,5678
        return result
    }
    
    func depar(solution: String, leftPar: Int, rightPar: Int) -> String{
//        print("Solution: \(solution) leftPar: \(leftPar) rightPar: \(rightPar)")
        var inner = solution.substring(start: leftPar + 1, end: rightPar)
        
        var opIndex: Int = 0
        var opInner: String = ""
        if inner[0] == "(" {
            // ...((oxo)Xo)... (X = opInner)
            opIndex = inner.indexDistanceJS(of: ")") + 1
            
        } else if (inner[inner.count - 1] == ")") {
            // ...(ox(oXo))...
            opIndex = inner.indexDistanceJS(of: "(") - 1
            
        } else {
            // ...(oXo)...
            opIndex = 1
        }
        
        opInner = String(inner[opIndex])
        
        while Int(opInner) != nil{
            opIndex += 1
            opInner = String(inner[opIndex])
        }
        
        // opOuter
        var opLeft = "", opRight = "";
        if (leftPar > 0) {
            // oX(oxo)... (x = opInner, X = opOuter)
            opLeft = String(solution[leftPar - 1])
        }
        if (rightPar < solution.count - 1) {
            // ...(oxo)Xo
            opRight = String(solution[rightPar + 1])
        }
        
        if (opInner == "+" || opInner == "-") {
            if (opLeft == "*" || opLeft == "/" || opRight == "*" || opRight == "/") {
               
                return solution
            }
            if (opLeft == "-") {
                // o-(o+o)... => o-o-o... , o-(o-o)... => o-o+o...
                
                inner = inner.substring(start: 0, end: opIndex) + (opInner == "+" ? "-" : "+") + inner.substring(start: opIndex + 1)
                
            }
        } else if (opLeft == "/") {
            // o/(o*o)... => o/o/o... , o/(o/o)... => o/o*o...
            
            inner = inner.substring(start: 0, end: opIndex) + (opInner == "*" ? "/" : "*") + inner.substring(start: opIndex + 1);
            
        }
        return solution.substring(start: 0, end: leftPar) + inner + solution.substring(start: rightPar + 1)
    }
    func renderOp(solution: String) -> String {
        return solution.replacingOccurrences(of: "+", with: " + ").replacingOccurrences(of: "-", with: " - ").replacingOccurrences(of: "*", with: " × ").replacingOccurrences(of: "/", with: " ÷ ")


    }

    func render(solution: String) -> String {
        
        let leftPar1 = solution.indexDistanceJS(of: "(")
        let leftPar2 = solution.indexDistanceJS(of: "(", from: leftPar1 + 1)
        let rightPar2 = solution.lastIndexDistanceJS(of: ")")
        let rightPar1 = solution.lastIndexDistanceJS(of: ")", from: rightPar2 - 1)
        if (leftPar2 < 0 || rightPar1 < 0) {
            
            return self.renderOp(solution: self.depar(solution: solution, leftPar: leftPar1, rightPar: rightPar2))
        }
        if (rightPar1 < leftPar2) {
            
            return self.renderOp(solution: self.depar(solution: self.depar(solution: solution, leftPar: leftPar2, rightPar: rightPar2), leftPar: leftPar1, rightPar: rightPar1))
        }
        var depared = self.depar(solution: solution, leftPar: leftPar1, rightPar: rightPar2)
        if (depared.count == solution.count) {
            let inner = depared.substring(start: leftPar1 + 1, end: rightPar2);

            depared = depared.substring(start:0, end: leftPar1) + "(" +
                self.depar(solution: inner, leftPar: inner.indexDistanceJS(of: "("), rightPar: inner.lastIndexDistanceJS(of: ")")) +
                ")" + depared.substring(start: rightPar2 + 1);
        } else {
            depared = self.depar(solution: depared, leftPar: depared.indexDistanceJS(of: "("), rightPar: depared.lastIndexDistanceJS(of: ")"));
        }
        return self.renderOp(solution: depared)
    }

}
