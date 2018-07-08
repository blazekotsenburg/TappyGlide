//
//  StartScene.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 6/28/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreImage

class StartScene : SKScene {
    
    private var sceneWidth:   CGFloat!
    private var sceneHeight:  CGFloat!
    private var glider:       SKSpriteNode!
    private var title:        SKSpriteNode!
    private var gameScene:    SKScene!
    
    override func didMove(to view: SKView) {
        
        sceneWidth  = self.scene?.frame.width
        sceneHeight = self.scene?.frame.height
        
        let gliderTexture: SKTexture = SKTexture(imageNamed: "gliderHomeImage.png")
        glider = SKSpriteNode(texture: gliderTexture)
        glider.position = CGPoint(x: sceneWidth/2.0, y: sceneHeight*0.66)
        
        let titleTexture: SKTexture = SKTexture(imageNamed: "tappyGlideTitle.png")
        title = SKSpriteNode(texture: titleTexture)
        title.position = CGPoint(x: sceneWidth/2.0, y: sceneHeight*0.85)
        
        generateGradientBackground()
        self.addChild(glider)
        self.addChild(title)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 1.5)
        gameScene = SKScene(fileNamed: "GameScene")
        gameScene.scaleMode = .aspectFit
        
        self.view?.presentScene(gameScene, transition: transition)
        
    }
    
    func generateGradientBackground() {
        
        let topColor    = CIColor(rgba: "#22A8AD")
        let bottomColor = CIColor(rgba: "#134E5E")
        let texture     = SKTexture(size: frame.size, color1: topColor, color2: bottomColor, direction: SKTexture.GradientDirection.up)
        
        texture.filteringMode = .nearest
        
        let sprite       = SKSpriteNode(texture: texture)
        sprite.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        sprite.size      = self.frame.size
        sprite.zPosition = -10
        
        self.addChild(sprite)
    }
}
