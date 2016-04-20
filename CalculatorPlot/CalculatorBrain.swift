//
//  CalculatorBrain.swift
//  StanfordCalculator
//
//  Created by Edwin Aaron Saenz on 2/18/15.
//  Copyright (c) 2015 Edwin Aaron Saenz. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class CalculatorBrain {
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, Int, (Double, Double) -> Double)
        case Constant(String, Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _, _):
                    return symbol
                case .Constant(let symbol, _):
                    return "\(symbol)"
                case .Variable(let symbol):
                    return "Variable \(symbol)"
                }
            }
        }
    }
    
    var variableValues = Dictionary<String,Double>()
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", Int.max, *))
        learnOp(Op.BinaryOperation("÷", Int.max) { $1 / $0 })
        learnOp(Op.BinaryOperation("+", 1, +))
        learnOp(Op.BinaryOperation("-", 1) { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("ᐩ/-") { $0 * -1 })
        learnOp(Op.Constant("π", M_PI))
    }
    
    var description: String {
        get {
            var description = ""
            var evaluation = evaluateDescription(opStack)
            while(evaluation.result != "?") {
                description = "\(evaluation.result), \(description)"
                evaluation = evaluateDescription(evaluation.remainingOps)
            }
            
            let lastIndex = description.endIndex.advancedBy(-2)
            return description[description.startIndex..<lastIndex]
        }
    }
    
    func clear() {
        opStack = [Op]()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func evaluateFrom0To100() -> [CGFloat]?{
        
        var floatArr = [CGFloat]();
        print("access evaluate from 0 to 100")
        if let num = variableValues["M"]{
            return nil;
        }
        else {
            print(" [][][] \(opStack)");

            let variableSt = opStack.filter{
                (op) in switch op{
                case .Variable(_): return true
                default: return false
                }
            }

            if variableSt.isEmpty {
                print("access variableset empty")
                return nil;
            }
            else{
                print(" ==== \(opStack)");
                for index in 0...5 {
                    variableValues["M"] = Double(index);
                    print("before evaluation M = \(variableValues["M"])")
                    if let res = evaluate(){
                        let resFloat = (String(format:"%.5f", res) as NSString).floatValue;
                        floatArr.append(CGFloat(resFloat));
                    }
                }
                variableValues["M"] = nil;
                return floatArr
            }
        }
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, _, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Constant(_, let constant):
                return (constant, remainingOps)
            case .Variable(let symbol):
                let value = variableValues[symbol]
                return (value, remainingOps)
            }
        }
        
        return (nil, ops)
    }
    
    
    private func evaluateDescription(ops: [Op]) -> (result: String, opPrecedence: Int, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .UnaryOperation(let symbol, _):
                let description = evaluateDescription(remainingOps)
                return ("\(symbol)(\(description.result))", Int.max, description.remainingOps)
            case .BinaryOperation(let symbol, let precedence,  _):
                let evaluation = evaluateDescription(remainingOps)
                let evaluation2 = evaluateDescription(evaluation.remainingOps)
                let evaluationsPrecedenceIsLower = evaluation.opPrecedence < precedence
                if evaluationsPrecedenceIsLower {
                    return ("\(evaluation2.result) " + symbol + " (\(evaluation.result))", precedence, evaluation2.remainingOps)
                } else {
                    return ("\(evaluation2.result) " + symbol + " \(evaluation.result)", precedence, evaluation2.remainingOps)
                }
            case .Operand(let operand):
                return ("\(operand)", Int.max, remainingOps)
            case .Constant(let constant, _):
                return ("\(constant)", Int.max, remainingOps)
            case .Variable(let variable):
                return ("\(variable)", Int.max, remainingOps)
            }
        }
        
        return ("?", Int.max, ops)
    }
}