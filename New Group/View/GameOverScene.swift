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
    private var gameOverLabel: SKLabelNode!
    private var startScene:    SKScene!
    private var sparkles:      SKEmitterNode!
    private var scoreLabel:    SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        sceneWidth  = self.scene?.frame.width
        sceneHeight = self.scene?.frame.height
        
        self.scene?.backgroundColor = UIColor.black
        
        let moveFromTop: SKAction = SKAction.moveTo(y: sceneHeight/2.0, duration: 1.5)
        let fadeIn:      SKAction = SKAction.fadeIn(withDuration: 1.5)

        gameOverLabel           = SKLabelNode(text: "Game Over")
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.alpha     = 0.0
        gameOverLabel.fontSize  = 90
        gameOverLabel.fontName  = "SpaceRangerItalic"
        gameOverLabel.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight + gameOverLabel.frame.height)
        gameOverLabel.run(SKAction.group([moveFromTop, fadeIn]))
        self.addChild(gameOverLabel)
        
        scoreLabel = SKLabelNode(text: "Score: \(self.userData?.value(forKey: "Score") as! Int)")
        scoreLabel.fontColor = UIColor.white
        scoreLabel.alpha     = 0.0
        scoreLabel.fontSize  = 45
        scoreLabel.fontName  = "SpaceRangerItalic"
        scoreLabel.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.5)
        scoreLabel.run(SKAction.fadeIn(withDuration: 2.5))
        self.addChild(scoreLabel)
        
        sparkles           = SKEmitterNode(fileNamed: "GameOverSparkle")
        sparkles.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        sparkles.zPosition = -1
        
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
