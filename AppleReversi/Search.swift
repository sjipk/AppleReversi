//
//  Search.swift
//  AppleReversi
//
//  Created by USER on 2017/07/29.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation

/// 最小スコア
let MinScore = Int(UInt8.min)
/// 最大スコア
let MaxScore = Int(UInt8.max)

/// ゲーム木を探索して最良のスコアを求めるプロトコル
protocol Search {
    func getBestScore(board: Board, color: CellState) -> Int
}

/// 探索アルゴリズム実装のための基底クラス
class SearchAlgorithmBase {
    
    // 評価関数
    let evaluate: EvaluationFunction
    
    // 探索する深さ
    let maxDepth: Int
    
    init(evaluate: @escaping EvaluationFunction, maxDepth: Int) {
        TRACE0()
        self.evaluate = evaluate
        self.maxDepth = maxDepth
    }
}

/// MinMax法による探索アルゴリズムの実装
class MiniMaxMethod : SearchAlgorithmBase, Search {

    func getBestScore(board: Board, color: CellState) -> Int {
        TRACE0()
//        return self.miniMax(node: board, color: color, depth: 1)
        
        let score = self.miniMax(node: board, color: color.opponent, depth: 2)
        
        return score
    }
    
    func miniMax(node: Board, color: CellState, depth: Int) -> Int {
        TRACE1()
        var count: Int = 0
        print("miniMax color:\(color) depth:\(depth)")
        print(node)
        
        
        if self.maxDepth <= depth {
            // 設定されている最大の深さに達したときに、評価値を算出
            return self.evaluate(node, color)
        }
        
        let moves = node.getValidMoves(color: color)
        
        if depth % 2 == 0 {
            // 対戦者のターン
            DLog(obj: "対戦者のターン" as AnyObject)
            var worstScore = MaxScore
            
            // 対戦者が取れるすべての合法な手の中から、自分に取って最悪のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move: move)

                print("N 回数 \(count)")
                print(testNode)
                
                // 色を切り替えて、試行用のノードのスコアを取得、より悪いほうを選択
                let score = self.miniMax(node: testNode, color: color.opponent, depth: depth + 1)
                DLog(obj: "N 結果 \(score)" as AnyObject)

                worstScore = min(worstScore, score)
                count += 1
            }
            TRACE2()
            return worstScore
        } else {
            // 自分のターン
            DLog(obj: "自分のターン" as AnyObject)
            var bestScore = MinScore
            // 自身が取れるすべての合法な手の中から、自分に取って最良のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move: move)
                
                print("M 回数 \(count)")
                print(testNode)
                
                // 色を切り替えて、試行用のノードのスコアを取得、より良いほうを選択
                let score = self.miniMax(node: testNode, color: color.opponent, depth: depth + 1)
                DLog(obj: score as AnyObject)
                
                bestScore = max(bestScore, score)
                count += 1
            }
            TRACE2()
            return bestScore
        }
    }
}

/// Alpha-Beta法による探索アルゴリズムの実装
class AlphaBetaPruning : SearchAlgorithmBase, Search {

    func getBestScore(board: Board, color: CellState) -> Int {
        TRACE0()
        
        let score = self.alphaBata(node: board, color: color.opponent, depth: 2, alpha: MinScore, beta: MaxScore)
        
        return score
    }
    
    func alphaBata(node: Board, color: CellState, depth: Int, alpha: Int, beta: Int) -> Int {
        TRACE1()
        var beta = beta
        var alpha = alpha

        var count: Int = 0
        print("alphaBata color:\(color) depth:\(depth)")
        print(node)
        
        
        if self.maxDepth <= depth {
            // 設定されている最大の深さに達したときに、評価値を算出
            return self.evaluate(node, color)
        }
        
        let moves = node.getValidMoves(color: color)
        
        if depth % 2 == 0 {
            // 対戦者のターン
            DLog(obj: "対戦者のターン" as AnyObject)
            
            // 対戦者が取れるすべての合法な手の中から、自分に取って最悪のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move: move)
                
                print("N 回数 \(count)")
                print(testNode)
                
                // 色を切り替えて、試行用のノードのスコアを取得、より悪いほうを選択
                let score = self.alphaBata(node: testNode, color: color.opponent, depth: depth + 1, alpha: alpha, beta: beta)
                DLog(obj: "N 結果 \(score)" as AnyObject)
                
                beta = min(beta, score)
                if beta <= alpha {
                    return beta // bataカット
                }
                
                count += 1
            }
            TRACE2()
            return beta
        } else {
            // 自分のターン
            DLog(obj: "自分のターン" as AnyObject)
            // 自身が取れるすべての合法な手の中から、自分に取って最良のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move: move)
                
                print("M 回数 \(count)")
                print(testNode)
                
                // 色を切り替えて、試行用のノードのスコアを取得、より良いほうを選択
                let score = self.alphaBata(node: testNode, color: color.opponent, depth: depth + 1, alpha: alpha, beta: beta)
                DLog(obj: score as AnyObject)
                
                alpha = max(alpha, score)
                if beta <= alpha {
                    return alpha // alphaカット
                }
                
                count += 1
            }
            TRACE2()
            return alpha
        }
    }
}


