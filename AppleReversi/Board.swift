//
//  Board.swift
//  AppleReversi
//
//  Created by USER on 2017/07/11.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation

/// 磐の一辺のセルの数
let BoardSize = 8

/// 8 * 8 の盤面
class Board : CustomStringConvertible {
    
    // 盤上のすべてのセルの状態を保持する二次元配列
    var cells: Array2D<CellState>

    // イニシャライザ
    init(cells: Array2D<CellState>) {
        TRACE0()
        self.cells = cells
    }
    
    // イニシャライザ
    init() {
        TRACE0()
        self.cells = Array2D<CellState>(rows: BoardSize, columns: BoardSize, repeatedValue: .Empty)
        
        self.cells[3, 4] = .Black
        self.cells[4, 3] = .Black
        self.cells[3, 3] = .White
        self.cells[4, 4] = .White
    }
    
    func clone() -> Board {
        TRACE0()
        return Board(cells: self.cells)
    }
    
    // 指定された色の合法な手の一覧を返す
    func getValidMoves(color: CellState) -> [Move] {
        var moves = Array<Move>()
        
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                let move = Move(color: color, row: row, column: column)
                if move.canPlace(cells: self.cells) {
                    moves.append(move)
                }
            }
        }
        
        return moves
    }
    
    var description: String {
        var rows = Array<String>()
        for row in 0..<BoardSize {
            var cells = Array<String>()
            for column in 0..<BoardSize {
                if let state = self.cells[row, column] {
                    cells.append(String(state.rawValue))
                }
            }
            let line = cells.joined(separator: " ")
            rows.append(line)
        }
        return rows.reversed().joined(separator: "\n")
    }
    
    /// 手を打つ
    func makeMove(move: Move) {
        TRACE1()
        for vertical in Line.allValues {
            for horizontal in Line.allValues {
                if vertical == .Hold && horizontal == .Hold {
                    continue
                }
                let direction = (vertical, horizontal)
                let count = move.countFlippableDisks(direction: direction, cells: self.cells)
                
                if 0 < count {
                    // 石を返す
                    let y = vertical.rawValue
                    let x = horizontal.rawValue
                    for i in 1...count {
                        self.cells[move.row + i * y, move.column + i * x] = move.color
                    }
                }
            }
        }
        // 石を置く
        self.cells[move.row, move.column] = move.color
        TRACE2()
    }
    
    /// 指定された状態のセルの数を返す
    func countCells(state: CellState) -> Int {
        TRACE1()
        var count = 0
        for row in 0..<self.cells.rows {
            for column in 0..<self.cells.columns {
                if self.cells[row, column] == state {
                    count += 1
                }
            }
        }
        TRACE2()
        return count
    }
    
    /// ゲームが終了した場合、trueを返す
    func hasGameFinished() -> Bool {
        TRACE0()
        return self.existsValidMove(color: .Black) == false && self.existsValidMove(color: .White) == false
    }
    
    /// 合法な手が存在する場合、trueを返す
    func existsValidMove(color: CellState) -> Bool {
        TRACE1()
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                let move = Move(color: color, row: row, column: column)
                if move.canPlace(cells: self.cells) {
                    TRACE2()
                    return true
                }
            }
        }
        TRACE2()
        return false
    }
}
