//
//  GameScene.swift
//  AppleReversi
//
//  Created by USER on 2017/07/05.
//  Copyright © 2017年 USER. All rights reserved.
//

import SpriteKit

// マス目のサイズ
let SquareHeight: CGFloat = 38.0
let SquareWidth: CGFloat = 38.0

// 石のイメージファイルの名前
let DiskImageNames = [
    CellState.Black : "black",
    CellState.White : "white",
]

extension SKLabelNode {
    /// スコア表示用のSKLabelNodeを生成する
    class func createScoreLabel(x: Int, y: Int) ->SKLabelNode {
        let node = SKLabelNode(fontNamed: "Zapfino")
        node.position = CGPoint(x: x, y: y)
        node.fontSize = 25
        node.horizontalAlignmentMode = .right
        node.fontColor = UIColor.white
        node.zPosition = 1      //
        return node
    }
}


class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let disksLayer = SKNode()
    
    var diskNodes = Array2D<SKSpriteNode>(rows: BoardSize, columns: BoardSize)
    var board: Board!
    var nextColor: CellState!

    let blackScoreLabel = SKLabelNode.createScoreLabel(x: 150, y: -220)
    let whiteScoreLabel = SKLabelNode.createScoreLabel(x: 150, y: -263)
    
    var gameResultLayer: SKNode?
    
//    var gameFinishHandler
    
    var switchTurnHandler: (() -> ())?
    
    override func didMove(to view: SKView) {
        //基準点を中心に設定
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // 背景の設定
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.zPosition = 0        //
        self.addChild(background)
        self.addChild(self.gameLayer)
        
        // anchorPointからの相対位置(2017-8-3: yに+8する)
        let layerPosition = CGPoint(x: -SquareWidth * CGFloat(BoardSize) / 2, y: -SquareHeight * CGFloat(BoardSize) / 2 + 8)
        
        self.gameLayer.addChild(self.blackScoreLabel)
        self.gameLayer.addChild(self.whiteScoreLabel)
        
        self.disksLayer.position = layerPosition
        self.gameLayer.addChild(self.disksLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self.disksLayer)
        
        if let (row, column) = self.convertPointOnBoard(point: location!) {
//            print("{\(row), \(column)}")
            
            let move = Move(color: self.nextColor, row: row, column: column)
//            print(move.canPlace(cells: self.board.cells))
            
            if move.canPlace(cells: self.board.cells) {
/*
                // 盤上に手を打つ
                self.board.makeMove(move: move)
                
//                print(self.board.countCells(state: self.nextColor))
                
                // 今打った石と返された石を画面上に表示
                self.updateDiskNodes()
                
                // ゲームが終了したか検証する
                if self.board.hasGameFinished() {
                    // ゲーム終了時
                    self.showGameResult()
                }
                
                // 今打った手とは反対の色に変える
                self.nextColor = self.nextColor.opponent
 */
                self.makeMove(move: move)
                if self.board.hasGameFinished() == false {
                    self.switchTurnHandler?()
                }
            }
        }
    }
    
    /// 手を打つ
    func makeMove(move: Move) {
        
        // 盤上に手を打つ
        self.board.makeMove(move: move)
        
//        print(self.board.countCells(state: self.nextColor))
        
        // 今打った手とは反対の色に変える
        self.nextColor = self.nextColor.opponent
        // 今打った石と返された石を画面上に表示
        self.updateDiskNodes()
        
        // ゲームが終了したか検証する
        if self.board.hasGameFinished() {
            // ゲーム終了時
            self.showGameResult()
        }
    }
    
    func convertPointOnBoard(point: CGPoint) -> (row: Int, column: Int)? {
        if 0 <= point.x && point.x < SquareWidth * CGFloat(BoardSize) &&
            0 <= point.y && point.y < SquareHeight * CGFloat(BoardSize) {
            return (Int(point.y / SquareHeight), Int(point.x / SquareWidth))
        }else{
            return nil
        }
    }
    
    /// スコアを更新する
    func updateScores() {
        self.blackScoreLabel.text = String(self.board.countCells(state: .Black))
        self.whiteScoreLabel.text = String(self.board.countCells(state: .White))
    }
    
    /// リザルト画面を表示する
    func showGameResult() {
        let black = self.board.countCells(state: .Black)
        let white = self.board.countCells(state: .White)
        
        // 勝敗に対応した画像を読み込んだノード
        var resultImage: SKSpriteNode
        if white < black {
            resultImage = SKSpriteNode(imageNamed: "win_black")
        }else if (black < white) {
            resultImage = SKSpriteNode(imageNamed: "win_white")
        }else {
            resultImage = SKSpriteNode(imageNamed: "draw")
        }
        
        // 画像の縦幅の調整
        let sizeRatio = self.size.width / resultImage.size.width
        let imageHeight = resultImage.size.height * sizeRatio
        resultImage.size = CGSize(width: self.size.width, height: imageHeight)
        resultImage.zPosition = 2
        
//        let gameResultLayer = SKNode()
        let gameResultLayer = GameResultLayer()
        gameResultLayer.isUserInteractionEnabled = true
        gameResultLayer.touchHandler = self.hideGameResult
        gameResultLayer.addChild(resultImage)
        
        self.gameResultLayer = gameResultLayer
        self.addChild(self.gameResultLayer!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    /// 盤の初期化
    func initBoard() {
        self.board = Board()
        self.updateDiskNodes()
        self.nextColor = .Black
    }
    
    /// 現在の状態で、石の表示を更新する
    func updateDiskNodes() {
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                if let state = self.board.cells[row, column] {
                    if let imageName = DiskImageNames[state] {
                        if let prevNode = self.diskNodes[row, column] {
                            if prevNode.userData?["state"] as! Int == state.rawValue {
                                // 変化の無いセルはスキップする
                                continue
                            }
                            // 古いノードを削除
                            prevNode.removeFromParent()
                        }
                        
                        // 新しいノードをレイヤーに追加
                        let newNode = SKSpriteNode(imageNamed: imageName)
                        newNode.userData = ["state" : state.rawValue] as NSMutableDictionary
                        
                        newNode.size = CGSize(width: SquareWidth, height: SquareHeight)
                        newNode.zPosition = 1 //
                        newNode.position = self.convertPointOnLayer(row: row, column: column)
                        self.disksLayer.addChild(newNode)
                        
                        self.diskNodes[row, column] = newNode
                    }
                }
            }
        }
        // スコア表示の更新
        self.updateScores()
    }
    
    /// 盤上での座標をレイヤー上での座標に変換する
    func convertPointOnLayer(row: Int, column: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column) * SquareWidth + SquareWidth / 2, y: CGFloat(row) * SquareHeight + SquareHeight / 2)
    }
    
    /// ゲームをリスタートする
    func restartGame() {
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                if let diskNode = self.diskNodes[row, column] {
                    diskNode.removeFromParent()
                    self.diskNodes[row, column] = nil
                }
            }
        }
        
        self.initBoard()
    }
    
    /// リザルト画面を非表示にする
    func hideGameResult() {
        self.gameResultLayer?.removeFromParent()
        self.gameResultLayer = nil
        
        self.restartGame()
    }
}

/// ゲームリザルト用ノード
class GameResultLayer: SKNode {
    
    var touchHandler: (() -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler?()
    }
}
