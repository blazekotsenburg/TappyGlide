//
//  StartScene.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 6/28/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene : SKScene {
    
    private var sceneWidth:   CGFloat!
    private var sceneHeight:  CGFloat!
    private var highScore:    SKLabelNode!
    private var glider:       SKSpriteNode!
    private var title:        SKSpriteNode!
    private var startButton:  SKSpriteNode!
    private var gliderTrack:  SKSpriteNode!
    private var gameScene:    SKScene!
    
    override func didMove(to view: SKView) {
        
        //should read from the userDefaults here to set userData for scene ie self.userData = userdefaults...
        let userDefaults = UserDefaults.standard
        self.userData = self.userData ?? NSMutableDictionary()
        self.userData?.setValue(userDefaults.integer(forKey: "ExtraLifeCount"), forKey: "ExtraLifeCount")
        self.userData?.setValue(userDefaults.integer(forKey: "HighScore"), forKey: "HighScore")
        
        sceneWidth  = self.scene?.frame.width
        sceneHeight = self.scene?.frame.height
        
        let gliderTexture: SKTexture = SKTexture(imageNamed: "gliderHomeImage.png")
        glider                       = SKSpriteNode(texture: gliderTexture)
        glider.position              = CGPoint(x: sceneWidth/2.0, y: sceneHeight*0.66)
        
        let titleTexture: SKTexture = SKTexture(imageNamed: "tappyGlideTitle.png")
        title                       = SKSpriteNode(texture: titleTexture)
        title.position              = CGPoint(x: sceneWidth/2.0, y: sceneHeight*0.85)
        
        let startButtonTexture: SKTexture = SKTexture(imageNamed: "tappyGlideStart.png")
        startButton                       = SKSpriteNode(texture: startButtonTexture)
        startButton.position              = CGPoint(x: sceneWidth/2.0, y: sceneHeight*0.15)
        
        let gliderTrackTexture: SKTexture = SKTexture(imageNamed: "tappyGlideStartTrack.png")
        gliderTrack                       = SKSpriteNode(texture: gliderTrackTexture)
        gliderTrack.position              = CGPoint(x: glider.position.x, y: glider.position.y - 300)
        
        let bounceUpAction:   SKAction = SKAction.move(to: CGPoint(x: startButton.position.x, y: startButton.position.y + 10), duration: 1.5)
        let bounceDownAction: SKAction = SKAction.move(to: CGPoint(x: startButton.position.x, y: startButton.position.y - 10), duration: 1.5)
        
        startButton.run(SKAction.repeatForever(SKAction.sequence([bounceUpAction, bounceDownAction])))
        
        highScore = SKLabelNode(text: "High Score: \(userDefaults.integer(forKey: "HighScore"), forKey: "HighScore")")
        //Finish implementing the highscore for the title screen.  Will need an image for highscore to match other titles
        
        generateGradientBackground()
        spawnStars()
        self.addChild(glider)
        self.addChild(title)
        self.addChild(startButton)
        self.addChild(gliderTrack)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let position = touch.location(in: self)
            let node     = self.atPoint(position)
            
            if node == startButton {
                
                let scaleUp = SKAction.scale(by: 1.15, duration: 0.25)
                
                startButton.run(scaleUp, completion: {
                    
                    let transition           = SKTransition.fade(withDuration: 1.5)
                    self.gameScene           = SKScene(fileNamed: "GameScene")
                    self.gameScene.scaleMode = .aspectFit
                    self.gameScene.userData  = self.userData
                    self.view?.presentScene(self.gameScene, transition: transition)
                })
            }
        }
    }
    
    func generateGradientBackground() {
        //#02080D
        let topColor    = CIColor(rgba: "#134E5E")
        let bottomColor = CIColor(rgba: "#02080D")
        let texture     = SKTexture(size: frame.size, color1: topColor, color2: bottomColor, direction: SKTexture.GradientDirection.up)
        
        texture.filteringMode = .nearest
        
        let sprite       = SKSpriteNode(texture: texture)
        sprite.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        sprite.size      = self.frame.size
        sprite.zPosition = -10
        
        self.addChild(sprite)
    }
    
    func spawnStars() {
        let starArr : [(CGFloat, TimeInterval, CGPoint)]
            starArr = [(0.10, 1.5, CGPoint(x: sceneWidth * 0.15, y: sceneHeight * 0.950)),
                       (0.15, 2.0, CGPoint(x: sceneWidth * 0.95, y: sceneHeight * 0.880)),
                       (0.12, 1.7, CGPoint(x: sceneWidth * 0.33, y: sceneHeight * 0.750)),
                       (0.09, 2.3, CGPoint(x: sceneWidth * 0.80, y: sceneHeight * 0.550)),
                       (0.11, 1.3, CGPoint(x: sceneWidth * 0.56, y: sceneHeight * 0.875)),
                       (0.14, 2.2, CGPoint(x: sceneWidth * 0.20, y: sceneHeight * 0.520))]
        
        for i in 0 ... starArr.count - 1 {
            
            let star       = StarSprite(scale: starArr[i].0)
            star.alpha     = 0
            star.position  = starArr[i].2
            star.zPosition = -1
            
            let fadeIn  = SKAction.fadeIn(withDuration: starArr[i].1)
            let fadeOut = SKAction.fadeOut(withDuration: starArr[i].1)
            star.run(SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut])))
            
            self.addChild(star)
        }
        
    }
}
