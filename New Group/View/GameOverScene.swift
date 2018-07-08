//
//  GameOverScene.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 7/8/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene : SKScene {
    
    private var sceneWidth:    CGFloat!
    private var sceneHeight:   CGFloat!
    private var gameOverLabel: SKSpriteNode!
    private var startScene:     SKScene!
    
    override func didMove(to view: SKView) {
        
        sceneWidth  = self.scene?.frame.width
        sceneHeight = self.scene?.frame.height
        
        let gameOverLabelTexture:SKTexture = SKTexture(imageNamed: "gameOverLabel")
        gameOverLabel = SKSpriteNode(texture: gameOverLabelTexture)
        gameOverLabel.position = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        
//        self.view?.backgroundColor = UIColor.black
        self.scene?.backgroundColor = UIColor.black
        self.addChild(gameOverLabel)
        
        startScene = SKScene(fileNamed: "StartScene")
        startScene.scaleMode = .aspectFit
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.presentScene(startScene)
    }
}
