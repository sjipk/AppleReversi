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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let view = self.view as! SKView? {
            // Load the SKScene
            let scene = GameScene()
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            scene.size = view.frame.size
                
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        board.makeMove(move: move)
        print(board)
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
