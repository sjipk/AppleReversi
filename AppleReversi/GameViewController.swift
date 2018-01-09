//
//  GameViewController.swift
//  AppleReversi
//
//  Created by USER on 2017/07/05.
//  Copyright © 2017年 USER. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    private var scene: GameScene!
    
    var cpu: ComputerPlayer!

    override func viewDidLoad() {
        TRACE1()
        super.viewDidLoad()
/*
        /// debug用表示
        let board = Board()
        print(board)
        
        /// Moveクラスのインスタンス作成
        let move = Move(color: .Black, row: 3, column: 2)
        /// 右方向に裏返すことができる石をコンソールに出力
        var count = move.countFlippableDisks(direction: (vertical: .Hold, horizontal: .Forward), cells: board.cells)
        print(count)
        /// 上方向に裏返すことができる石をコンソールに出力
        count = move.countFlippableDisks(direction: (vertical: .Forward, horizontal: .Hold), cells: board.cells)
        print(count)
*/
        if let view = self.view as! SKView? {
            // Load the SKScene
            scene = GameScene()
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.size = view.frame.size
            
//            DLog(obj: scene.size as AnyObject)
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
//        self.scene.gameFinishHandler = self.showGameResult
        self.scene.switchTurnHandler = self.switchTurn
        
/*
        board.makeMove(move: move)
        print(board)
 */
        let evaluate = countColor
        let maxDepth = 3
        let search = MiniMaxMethod(evaluate: evaluate, maxDepth: maxDepth)
        self.cpu = ComputerPlayer(color: .White, search: search)
        self.scene.initBoard()
        
//        self.scene.showGameResult()
        TRACE2()
        DSpace(obj: "" as AnyObject)
    }
    
    func switchTurn() {
        TRACE1()
        if self.scene.nextColor == self.cpu.color {
            self.scene.isUserInteractionEnabled = false
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(GameViewController.makeMoveByComputer), userInfo: nil, repeats: false)
        }
        TRACE2()
    }
    
    // コンピュータプレイヤーに一手打たせる
    func makeMoveByComputer() {
        TRACE1()
        DSpace(obj: "コンピュータプレイヤーに一手打たせる" as AnyObject)
//        print(self.scene.board)
        let nextMove = self.cpu.selectMove(board: self.scene.board!)
        self.scene.makeMove(move: nextMove!)
        
        // プレイヤーが合法な手を打てない場合は、プレイヤーのターンをスキップする
        if self.scene.board.hasGameFinished() == false && self.scene.board.existsValidMove(color: self.cpu.color.opponent) == false {
            self.makeMoveByComputer()
        }
        
        self.scene.isUserInteractionEnabled = true
        TRACE2()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
