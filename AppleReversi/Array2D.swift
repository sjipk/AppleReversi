//
//  Array2D.swift
//  AppleReversi
//
//  Created by USER on 2017/07/05.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation

struct Array2D<T> {
    /// 行数
    let rows: Int
    /// 列数
    let columns: Int
    /// 二次元配列の行優先順で格納した一次元配列
    private var array: [T?]
    
    /// 行と列を指定して、新規インスタンスを構築する
    init(rows: Int, columns: Int, repeatedValue: T? = nil) {
        self.rows = rows
        self.columns = columns
        self.array = Array<T?>(repeating: repeatedValue, count: rows * columns)
    }
    
    // 行番号と列番号を指定して、二次元配列中の要素を取得する
    subscript(row: Int, column: Int) -> T? {
        get {
            if row < 0 || self.rows <= row || column < 0 || self.columns <= column {
                return nil
            }
            let idx = row * self.columns + column
            return self.array[idx]
        }
        set(newValue) {
            self.array[row * self.columns + column] = newValue
        }
    }
}
