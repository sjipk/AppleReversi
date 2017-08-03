//
//  Evaluation.swift
//  AppleReversi
//
//  Created by USER on 2017/07/29.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation


/// 評価関数の型
typealias EvaluationFunction = (_ board: Board, _ color: CellState) -> Int

/// 盤上の色のみを評価値とする評価関数
func countColor(_ board: Board, _ color: CellState) -> Int {
    return board.countCells(state: color)
}
