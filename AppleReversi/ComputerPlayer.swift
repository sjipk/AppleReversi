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
        TRACE1()
        self.color = color
        self.search = search
        TRACE2()
    }
    
    // 手を選択する
    func selectMove(board: Board) -> Move? {
        TRACE1()
        var bestMove: Move?
        var bestScore = MinScore

        var count: Int = 0        
        print("最初の盤面")
        print(board)
        
        // 最良の手を探索
        // 使用可能な手をmoveアレイに書き出す
        let moves = board.getValidMoves(color: self.color)
        // 使用可能な手の最初の一手を持って来て検証してする。
        for nextMove in moves {
            let test = board.clone()
            test.makeMove(move: nextMove)
            
            
            print("回数 \(count)")
            print(test)
            
            let score = self.search.getBestScore(board: test, color: self.color)
            
            print("結果 \(count)")
            DLog(obj: score as AnyObject)

            if bestScore <= score {
                bestScore = score
                bestMove = nextMove
            }
            
            count += 1
        }
        TRACE2()
        return bestMove
    }
}
