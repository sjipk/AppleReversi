//
//  CellState.swift
//  AppleReversi
//
//  Created by USER on 2017/07/11.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation

/// 盤上のセルの状態
public enum CellState: Int {
    case Empty = 0, Black, White
    
    /// 相手側の色
    var opponent: CellState {
        switch self {
        case .Black:
            return .White
        case .White:
            return .Black
        default:
            return self
        }
    }
}
