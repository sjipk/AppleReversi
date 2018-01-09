//
//  Debug.swift
//
//  Created by USER on 2017/06/29.
//  Copyright © 2017年 USER. All rights reserved.
//

import Foundation

//
//  使い方： dLog(obj: "abc" as AnyObject?)
//

func DLog(obj: AnyObject?, function: String = #function, line: Int = #line) {
    #if DEBUG
        print("[Func:\(function) Line:\(line)] : \(obj!)")
    #endif
}

func DSpace(obj: AnyObject?) {
    #if DEBUG
        print("\(obj!)")
    #endif
}

func TRACE0(function: String = #function) {
    #if DEBUG
        print("Calling [func:\(function)]")
    #endif
}

func TRACE1(function: String = #function) {
    #if DEBUG
        print("Calling [func:\(function)] Start")
    #endif
}

func TRACE2(function: String = #function) {
    #if DEBUG
        print("Calling [func:\(function)] End")
    #endif
}
