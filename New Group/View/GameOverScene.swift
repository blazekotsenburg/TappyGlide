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
    private var startScene:    SKScene!
    private var sparkles:      SKEmitterNode!
    
    override func didMove(to view: SKView) {
        
        sceneWidth  = self.scene?.frame.width
        sceneHeight = self.scene?.frame.height
        
        let gameOverLabelTexture:SKTexture = SKTexture(imageNamed: "gameOverLabel")
        gameOverLabel                      = SKSpriteNode(texture: gameOverLabelTexture)
        gameOverLabel.position             = CGPoint(x: sceneWidth/2.0, y: sceneHeight + gameOverLabel.frame.height)
        gameOverLabel.alpha                = 0.0
        
        let moveFromTop: SKAction = SKAction.moveTo(y: sceneHeight/2.0, duration: 1.5)
        let fadeIn:      SKAction = SKAction.fadeIn(withDuration: 1.5)
        
        self.scene?.backgroundColor = UIColor.black
        self.addChild(gameOverLabel)

        gameOverLabel.run(SKAction.group([moveFromTop, fadeIn]))
        
        sparkles          = SKEmitterNode(fileNamed: "GameOverSparkle")
        sparkles.position = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        
        self.addChild(sparkles)
        
        startScene           = SKScene(fileNamed: "StartScene")
        startScene.scaleMode = .aspectFit
        
//        print(self.userData?.value(forKey: "Score") as! Int) // this is broken
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let transitionScene:SKTransition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(startScene, transition: transitionScene)
    }
}
