//
//  Move.swift
//  AppleReversi
//
//  Created by USER on 2017/07/11.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation

/// 一直線上の方向
enum Line: Int {
    case Backward = -1, Hold, Forward
    static let allValues: [Line] = [.Backward, .Hold, .Forward]
}

/// 盤面上での石を返す方向
typealias Direction = (vertical: Line, horizontal: Line)

/// 盤上のどちらに石を置くかを表す「手」
class Move {
    
    // この手で配置する石の色
    let color: CellState
    // 配置する座標の行番号
    let row: Int
    // 配置する座標の列番号
    let column: Int
    
    init(color: CellState, row: Int, column: Int) {
        self.color = color
        self.row = row
        self.column = column
    }
    
    /// この手の座標から見て、引数で渡されたDirectionの方向で裏返すことができる石の数を返す
    func countFlippableDisks(direction: Direction, cells: Array2D<CellState>) ->Int {
        
        // 垂直方向の進行方向を表す係数
        let y = direction.vertical.rawValue
        
        // 水平方向の進行方向を表す係数
        let x = direction.horizontal.rawValue
        
        // 相手の色
        let opponent = self.color.opponent
        
        // 指定された方向に相手の色が続いている数
        var count = 1
        
        while (cells[self.row + count * y, self.column + count * x] == opponent) {
            count += 1
        }
        
        // 相手の色が続いた後のセルが自分の色である場合、正常に裏返すことができる
        if cells[self.row + count * y, self.column + count * x] == self.color {
            return count - 1
        } else {
            return 0
        }
    }
    
}
