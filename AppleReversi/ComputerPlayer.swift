//
//  ComputerPlayer.swift
//  AppleReversi
//
//  Created by USER on 2017/07/29.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation


/// コンピュタープレイヤー
class ComputerPlayer {
    
    let color: CellState
    let search: Search
    
    init(color: CellState, search: Search) {
        self.color = color
        self.search = search
    }
    
    // 手を選択する
    func selectMove(board: Board) -> Move? {
        
        var bestMove: Move?
        var bestScore = MinScore
        
        // 最良の手を探索
        let moves = board.getValidMoves(color: self.color)
        for nextMove in moves {
            let test = board.clone()
            test.makeMove(move: nextMove)
            
            let score = self.search.getBestScore(board: test, color: self.color)
            
            if bestScore <= score {
                bestScore = score
                bestMove = nextMove
            }
        }
        
        return bestMove
    }
}
