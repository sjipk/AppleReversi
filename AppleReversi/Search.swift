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
        self.evaluate = evaluate
        self.maxDepth = maxDepth
    }
}

/// MinMax法による探索アルゴリズムの実装
class MiniMaxMethod : SearchAlgorithmBase, Search {

    func getBestScore(board: Board, color: CellState) -> Int {
        return self.miniMax(node: board, color: color, depth: 1)
    }
    
    func miniMax(node: Board, color: CellState, depth: Int) -> Int {
        
        if self.maxDepth <= depth {
            // 設定されている最大の深さに達したときに、評価値を算出
            return self.evaluate(node, color)
        }
        
        let moves = node.getValidMoves(color: color)
        
        if depth % 2 == 0 {
            // 対戦者のターン
            var worstScore = MaxScore
            
            // 対戦者が取れるすべての合法な手の中から、自分に取って最悪のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move: move)
                // 色を切り替えて、試行用のノードのスコアを取得、より悪いほうを選択
                let score = self.miniMax(node: testNode, color: color.opponent, depth: depth + 1)
                worstScore = min(worstScore, score)
            }
            return worstScore
        } else {
            // 自分のターン
            var bestScore = MinScore
            // 自身が取れるすべての合法な手の中から、自分に取って最良のスコアを選択する
            for move in moves {
                // 試行用のノードを複製、仮の手を打つ
                let testNode = node.clone()
                testNode.makeMove(move: move)
                // 色を切り替えて、試行用のノードのスコアを取得、より良いほうを選択
                let score = self.miniMax(node: testNode, color: color.opponent, depth: depth + 1)
                bestScore = max(bestScore, score)
            }
            return bestScore
        }
    }
}
