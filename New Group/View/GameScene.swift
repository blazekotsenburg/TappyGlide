//
//  GameScene.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 1/4/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreImage

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var gliderSprite: SKSpriteNode!
    private var gliderTrack:  SKSpriteNode!
    private var sceneWidth:   CGFloat!
    private var sceneHeight:  CGFloat!
    private var model:        Model!
    private var scoreLbl:     SKScoreLabel!
    private var extraLife:    SKScoreLabel!
    
    var spriteAnimations: [String] = ["gliderSpriteJump0.png", "gliderSpriteJump1.png", "gliderSpriteJump2.png", "gliderSpriteJump3.png"]
    var cloudImages: [String]      = ["cloud0.png", "cloud1.png"]
    private var gliderTextureAtlas = SKTextureAtlas()
    private var gliderTextureArray = [SKTexture]()
    var speedUpdated: [Bool]       = Array(repeatElement(false, count: 4))
    
    private var time:Int = 0
    
    override func didMove(to view: SKView) {
        
        model = Model()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // Get sprite animation frames ready to go
        gliderTextureAtlas = SKTextureAtlas(named: "gliderAnimations")
        
        for i in 0...gliderTextureAtlas.textureNames.count - 1 {
            
            let name = "gliderSpriteJump\(i)"
            gliderTextureArray.append(SKTexture(imageNamed: name))
        }
        
        sceneWidth  = self.scene?.size.width
        sceneHeight = self.scene?.size.height
        
        createGlider() // consider getting rid of function since it this code happens one time.
        
        //Position the track for the glider on the screen, assign color, and set zPosition
        gliderTrack           = SKSpriteNode(color: UIColor.purple, size: CGSize(width: 20.0, height: sceneHeight))
        gliderTrack.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        gliderTrack.zPosition = 4.0
        
        scoreLbl = SKScoreLabel(at: CGPoint(x: sceneWidth/4.0, y: sceneHeight/2.0) , with: "\(model.getScore())")
        extraLife = SKScoreLabel(at: CGPoint(x: sceneWidth * 0.85, y: sceneHeight * 0.9), with:"0/500")
        
        scoreLbl.setSize(with: 128.0)
        extraLife.setSize(with: 48.0)
        
        self.addChild(gliderTrack)
        self.addChild(scoreLbl)
        self.addChild(extraLife)
        generateGradientBackground()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        time += 1
        
        //Switch case for spawning frequencies and speed updates to enemy sprites.
        switch self.model.getScore() {
            
        case 0 ..< 8:
            
            if time > 90 {
                
                self.addChild(spawnEnemySprite(with: 1.0))

                time = Int(arc4random_uniform(40) + 1)
            }
            
        case 8 ..< 16:
            
            if time > 90 {
                
                self.addChild(spawnEnemySprite(with: 1.15))
                if !speedUpdated[0] {
                    
                    updateSpriteSpeeds(with: 1.15)
                    speedUpdated[0] = true
                }
                
                time = Int(arc4random_uniform(40) + 1)
            }
            
        case 16 ..< 24:
            
            if time > 90 {
                
                self.addChild(spawnEnemySprite(with: 1.25))
                if !speedUpdated[1] {
                    
                    updateSpriteSpeeds(with: 1.25)
                    speedUpdated[1] = true
                }
                
                time = Int(arc4random_uniform(40) + 1)
            }
            
        case 24 ..< 32:
            
            if time > 60 {
                
                self.addChild(spawnEnemySprite(with: 1.45))
                if !speedUpdated[2] {
                    
                    updateSpriteSpeeds(with: 1.45)
                    speedUpdated[2] = true
                }
                
                time = Int(arc4random_uniform(35) + 1)
            }
            
        default:
            
            if time > 60 {
                
                self.addChild(spawnEnemySprite(with: 1.65))
                if !speedUpdated[3] {
                    
                    updateSpriteSpeeds(with: 1.65)
                    speedUpdated[3] = true
                }
                
                time = Int(arc4random_uniform(40) + 1)
            }
        }
        
        spawnCloudsAndStars(speed: 1.0)
        checkForScoreUpdates()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (self.gliderSprite.physicsBody?.categoryBitMask)! | 0x1 { // 0x1 = collisionBitMask for enemy sprites
            
            let rotateGlider:SKAction = SKAction.rotate(byAngle: 45.0, duration: 5)
            self.gliderSprite.removeAllChildren()
            self.gliderSprite.run(SKAction.repeatForever(rotateGlider))
            self.gliderSprite.physicsBody?.velocity = CGVector(dx: 200.0, dy: -200.0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.gliderSprite.removeAllChildren()
        
        self.gliderSprite.physicsBody?.categoryBitMask    = 0x0
        self.gliderSprite.physicsBody?.collisionBitMask   = 0x0
        self.gliderSprite.physicsBody?.contactTestBitMask = 0x0
        
        let scaleUp     = SKAction.scale(by: 4.0, duration: 0.75)
        let scaleDown   = SKAction.scale(by: 0.25, duration: 0.75)
        let ascend      = SKAction.animate(with: gliderTextureArray, timePerFrame: 0.2, resize: false, restore: false)
        let wait        = SKAction.wait(forDuration: 0.2)
        let descend     = SKAction.animate(with: gliderTextureArray.reversed(), timePerFrame: 0.2, resize: false, restore: false)
        let gliderTrail = SKEmitterNode(fileNamed: "GliderTrail")!
        
        self.gliderSprite.run(SKAction.group([scaleUp, ascend, wait]))
        self.gliderSprite.run(SKAction.group([scaleDown, descend]), completion: {
            
            gliderTrail.position  = CGPoint(x: 0.0, y: -self.gliderSprite.size.height/2.0)
            gliderTrail.zPosition = (self.gliderSprite.zPosition - 1)
            self.gliderSprite.addChild(gliderTrail)
            
            self.gliderSprite.physicsBody?.categoryBitMask    = 0x2
            self.gliderSprite.physicsBody?.collisionBitMask   = 0x1
            self.gliderSprite.physicsBody?.contactTestBitMask = 0x1
        })
        
        
        
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
    
    func createGlider() {
        
        //Position the player's glider on the screen, assign color, and set zPosition
        let gliderTexture:SKTexture      = SKTexture(imageNamed: "gliderSprite.png")
        let gliderSpriteCategory: UInt32 = 0x1 << 1
        
        gliderSprite             = SKSpriteNode(texture: gliderTexture)
        gliderSprite.physicsBody = SKPhysicsBody(texture: gliderTexture, size: CGSize(width: gliderSprite.size.width/2, height: gliderSprite.size.height/2))
        
        gliderSprite.physicsBody?.categoryBitMask    = gliderSpriteCategory
        gliderSprite.physicsBody?.collisionBitMask   = 0x1
        gliderSprite.physicsBody?.contactTestBitMask = 0x1
        
        gliderSprite.position  = CGPoint(x: sceneWidth/2.0, y: 200.0)
        gliderSprite.zPosition = 6.0
        
        let gliderTrail       = SKEmitterNode(fileNamed: "GliderTrail")!
        gliderTrail.position  = CGPoint(x: 0.0, y: -gliderSprite.size.height/2.0)
        gliderTrail.zPosition = (gliderSprite.zPosition - 1)
        
        gliderSprite.addChild(gliderTrail)
        
        self.addChild(gliderSprite)
    }
    
    func spawnEnemySprite(with speed: CGFloat) -> SKShapeNode {
        
        let enemySprite   = Enemy(circleOfRadius: 25.0, at: CGPoint(x: sceneWidth/2.0 , y: sceneHeight)) //not sure why the -75 offset needs to be
        enemySprite.speed = speed
        
        enemySprite.run(SKAction.moveTo(y: -sceneHeight, duration: 8.0))
        
        return enemySprite
    }
    
    func updateSpriteSpeeds(with speed: CGFloat) {
        
        self.enumerateChildNodes(withName: "enemy") { (node:SKNode, nil) in
            
            if let current = node as? Enemy {
                current.speed = speed
            }
        }
    }
    
    func spawnCloudsAndStars(speed: CGFloat) {
        
        var spawnCloud = arc4random_uniform(1000) + 1
        var spawnStar  = arc4random_uniform(1000) + 1
        
        if spawnCloud >= 1 && spawnCloud <= 10 {
            
            spawnCloud = UInt32(spawnCloud) & 1
            
            let cloud   = SKSpriteNode(imageNamed: cloudImages[Int(spawnCloud)])
            cloud.name  = "cloud"
            cloud.speed = ((2.0 * CGFloat(spawnCloud)) + 1.0) - 0.25
            let xSpawn  = CGFloat(arc4random_uniform(UInt32(self.sceneWidth)))
            let move    = SKAction.moveTo(y: -self.sceneHeight, duration: 15.0)
            
            cloud.run(move)
            
            cloud.position = CGPoint(x: xSpawn, y: self.sceneHeight + frame.height/2.0)
            
            self.addChild(cloud)
        }
        
        if spawnStar >= 1 && spawnStar <= 10 {
            
            spawnStar               = UInt32(spawnStar) & 1
            let scaleArr:[CGFloat]  = [0.15,0.25]
            let scaledSize:CGFloat  = scaleArr[Int(arc4random_uniform(2))]
            let xSpawn:CGFloat      = CGFloat(arc4random_uniform(UInt32(self.sceneWidth)))
            
            //Check bounds for spawning a star (+-15 from center screen)
            if (xSpawn > 0 && xSpawn < self.sceneWidth/2 - 15) || (xSpawn > self.sceneWidth/2 + 15 && xSpawn < self.sceneWidth) {
                
                let star   = StarSprite(scale: scaledSize)
                star.name  = "star"
                star.speed = ((2.0 * CGFloat(spawnStar)) + 1.0) - 0.25
                
                let move = SKAction.moveTo(y: -self.sceneHeight, duration: 15.0)
                star.run(move)
                
                star.position = CGPoint(x: xSpawn, y: self.sceneHeight + frame.height/2.0)
                
                self.addChild(star)
            }
        }
    }
    
    
    func checkForScoreUpdates() {
        
        self.enumerateChildNodes(withName: "enemy") { (node:SKNode, nil) in
            //will need to make this a different loop so that Enemy can be used.
            if let current = node as? Enemy {
                
                if (current.position.y < self.gliderSprite.position.y) && (!current.hasBeenScored()) {
                    self.model.updateScore()
                    self.model.updateLifeCount()
                    self.updateScoreLabel()
                    current.setEnemyAsScored()
                }
                
                if node.position.y < (0 - node.frame.size.height * 2.0) {
                    node.removeFromParent()
                }
            }
        }
        
        self.enumerateChildNodes(withName: "cloud") { (node:SKNode, nil) in
            
            if node.position.y < 0 - node.frame.size.height*2 {
                node.removeFromParent()
            }
        }
        
        self.enumerateChildNodes(withName: "star") { (node:SKNode, nil) in
            
            if node.position.y < 0 - node.frame.size.height*2 {
                node.removeFromParent()
            }
        }
    }
    
    func updateScoreLabel() {
        
        self.scoreLbl.text  = "\(self.model.getScore())"
        self.extraLife.text = "\(self.model.getLifeCount())/500" //prints parentheses
        
        self.scoreLbl.animateScore()
    }
}

/******************* External Extensions *******************/

//
//  The following extension is used to help provide a gradient background to an SKScene by creating
//  a gradient SKTexture and then adding the texture to an SKShapeNode or SKSpriteNode.
//
//    Linear gradient texture
//    Based on: https://gist.github.com/Tantas/7fc01803d6b559da48d6, https://gist.github.com/craiggrummitt/ad855e358004b5480960
//
//  Created by Maxim on 1/1/16.
//  Copyright © 2016 Maxim Bilan. All rights reserved.
//

public extension SKTexture {
    
    public enum GradientDirection {
        case up
        case left
        case upLeft
        case upRight
    }
    
    convenience init(size: CGSize, color1: CIColor, color2: CIColor, direction: GradientDirection = .up) {
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector
        
        filter!.setDefaults()
        
        switch direction {
        case .up:
            startVector = CIVector(x: size.width * 0.5, y: 0)
            endVector = CIVector(x: size.width * 0.5, y: size.height)
        case .left:
            startVector = CIVector(x: size.width, y: size.height * 0.5)
            endVector = CIVector(x: 0, y: size.height * 0.5)
        case .upLeft:
            startVector = CIVector(x: size.width, y: 0)
            endVector = CIVector(x: 0, y: size.height)
        case .upRight:
            startVector = CIVector(x: 0, y: 0)
            endVector = CIVector(x: size.width, y: size.height)
        }
        
        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")
        
        let image = context.createCGImage(filter!.outputImage!, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(cgImage: image!)
    }
}

//
//  CIColorRGBA.swift
//
//
//  Created by Maxim on 1/1/16.
//  Copyright © 2016 Maxim Bilan. All rights reserved.
//

public extension CIColor {
    
    convenience init(rgba: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        if rgba.hasPrefix("#") {
            let index = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex = rgba[index...]
            let scanner = Scanner(string: String(hex))
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    break;
                }
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
