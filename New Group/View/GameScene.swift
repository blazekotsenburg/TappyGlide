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
import AVFoundation

class GameScene : SKScene, SKPhysicsContactDelegate {
    
    private var gliderSprite:       SKSpriteNode!
    private var gliderTrack:        SKSpriteNode!
    private var sceneWidth:         CGFloat!
    private var sceneHeight:        CGFloat!
    private var player:             Player!
    private var scoreLbl:           SKScoreLabel!
    private var extraLife:          SKScoreLabel!
    private var spawnTimer:         Timer!
    private var enemyTexture:       SKTexture!
    private var gameOverScene:      SKScene!
    private var pop:                PopUpNode!
    private var gameViewController: GameViewController!
    private var backgroundMusic:    SKAudioNode!
    private var avqPlayer:          AVQueuePlayer!
    private var avqPlayerLooper:    AVPlayerLooper!
    
    private var spriteAnimations: [String] = ["gliderSpriteJump0.png", "gliderSpriteJump1.png", "gliderSpriteJump2.png", "gliderSpriteJump3.png"]
    private var cloudImages:      [String] = ["cloud0.png", "cloud1.png"]
    
    private var gliderTextureAtlas = SKTextureAtlas()
    private var gliderTextureArray = [SKTexture]()
    
    private var enemyTextureAtlas  = SKTextureAtlas()
    private var enemyTextureArray  = [SKTexture]()
    
    var speedUpdated: [Bool]       = Array(repeatElement(false, count: 4))
    
    private var animationIsInProgress: Bool         = false
    private var time:                  Int          = 1
    private var prevTime:              TimeInterval = 0
    private var currSpeed:             CGFloat      = 1.0
    
    override func didMove(to view: SKView) {
        
        gameViewController = self.view?.window?.rootViewController as! GameViewController
        self.gameViewController.loadGoogleAd()
        
//        avqPlayer = AVQueuePlayer()
//
//        guard let url = Bundle.main.url(forResource: "TGThemeSong", withExtension: "wav") else { return }
//        let playerItem = AVPlayerItem(asset: AVAsset(url: url))
//        avqPlayerLooper = AVPlayerLooper(player: avqPlayer, templateItem: playerItem)
//        avqPlayer.play()
        
        if let bckgndUrl = Bundle.main.url(forResource: "TGThemeSong", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: bckgndUrl)
            backgroundMusic.autoplayLooped = true
        }
        
        let storedExtraLifeCount = self.userData?.value(forKey: "ExtraLifeCount") as! Int
        let storedHighScore      = self.userData?.value(forKey: "HighScore")      as! Int
        
        player = Player()
        player.setLifeCount(score: storedExtraLifeCount)
        player.updateHighScore(newHighScore: storedHighScore)

        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        // Get sprite animation frames ready to go
        gliderTextureAtlas = SKTextureAtlas(named: "gliderAnimations")
        enemyTexture       = SKTexture(imageNamed: "tappyGlideEnemy.png")
        
        // Organize all glider images so that animations can be run on them in order.
        for i in 0...gliderTextureAtlas.textureNames.count - 1 {
            
            let name = "gliderSpriteJump\(i)"
            gliderTextureArray.append(SKTexture(imageNamed: name))
        }
        
        sceneWidth  = self.scene?.frame.width
        sceneHeight = self.scene?.frame.height
        
        gliderSprite = createGlider()
        
        //Position the track for the glider on the screen, assign color, and set zPosition
        gliderTrack           = SKSpriteNode(color: UIColor.purple, size: CGSize(width: 20.0, height: sceneHeight))
        gliderTrack.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        gliderTrack.zPosition = 4.0
        
        scoreLbl = SKScoreLabel(at: CGPoint(x: sceneWidth/4.0, y: sceneHeight/2.0) , with: "\(player.getScore())")
        extraLife = SKScoreLabel(at: CGPoint(x: sceneWidth * 0.85, y: sceneHeight * 0.9), with:"\(player.getLifeCount())/500")
        
        scoreLbl.setSize(with: 128.0)
        extraLife.setSize(with: 48.0)
        
        gameOverScene = SKScene(fileNamed: "GameOverScene")
        gameOverScene.scaleMode = .aspectFit
        gameOverScene.userData = self.userData
        
        pop = PopUpNode(texture: nil, color: SKColor.white, size: CGSize(width: 500, height: 700))
        pop.position = CGPoint(x: sceneWidth/2.0, y: sceneHeight/2.0)
        pop.name = "PopUpMenu"
        self.addChild(pop)
        
        self.addChild(gliderSprite)
        self.addChild(gliderTrack)
        self.addChild(scoreLbl)
        self.addChild(extraLife)
        self.addChild(backgroundMusic)
        generateGradientBackground()
        
//        let topColor    = CIColor(rgba: "#134E5E")
//        let bottomColor = CIColor(rgba: "#02080D")
        
        spawnTimer = Timer()
    }
    
    func startTimer() {
        guard spawnTimer == nil else { return }
        // After a move towards maintainting collection of settings, change something in new interval based on score so the
        // spawn rates get slightly faster but still playable.
        let newInterval = player.getIntervalFromQueue()
//        if (abs(prevTime - newInterval) <= 0.6) {
//            newInterval = 0.8
//        }
//        if prevTime == newInterval {
//            newInterval += 0.1
//            print("prevTime: \(prevTime), newInterval: \(newInterval)")
//        }
        spawnTimer = Timer.scheduledTimer(timeInterval: newInterval, target: self, selector: #selector(GameScene.spawn), userInfo: nil, repeats: false)
//        prevTime = newInterval
    }
    
    func stopTimer() {
        guard spawnTimer != nil else { return }
        spawnTimer?.invalidate()
        spawnTimer = nil
    }
    
    @objc func spawn () {
        spawnCloudsAndStars(speed: 1.0)
        self.addChild(spawnEnemySprite(with: self.currSpeed))
        stopTimer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        startTimer()
        let score = self.player.getScore()

        switch score {

        case 8 ..< 16:

            if (!speedUpdated[0] && !animationIsInProgress) {

                self.currSpeed = 1.15
                updateSpriteSpeeds(with: self.currSpeed)
                speedUpdated[0] = true
                player.index += 1
            }
        break

        case 16 ..< 24:

            if (!speedUpdated[1] && !animationIsInProgress) {

                self.currSpeed = 1.25
                updateSpriteSpeeds(with: self.currSpeed)
                speedUpdated[1] = true
                player.index += 1
            }
        break

        case 24 ..< 32:

            if(!speedUpdated[2] && !animationIsInProgress) {

                self.currSpeed = 1.45
                updateSpriteSpeeds(with: self.currSpeed)
                speedUpdated[2] = true
                player.index += 1
            }

        case let x where x >= 32:

            if(!speedUpdated[3] && !animationIsInProgress) {

                self.currSpeed = 1.65
                updateSpriteSpeeds(with: self.currSpeed)
                speedUpdated[3] = true
            }
        break

        default:
            updateSpriteSpeeds(with: 1.0)
        }
        
        checkForScoreUpdates()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (self.gliderSprite.physicsBody?.categoryBitMask)! | 0x1 { // 0x1 = collisionBitMask for enemy sprites
            
            if !player.hasAnExtraLife() { // not updating correctly to make it work, collision happend before update
                if player.isNewTurn {
                    player.isNewTurn = false
                    self.scene?.isPaused = true
                    self.pop.isHidden = false
                }
                else { gameOver() }
            }
            else {
                player.resetExtraLife()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // If a glider animation is already in progress, prevent the player from triggering the animation on
        // multiple touchesEnded events.
        if (!animationIsInProgress) {
            
            animationIsInProgress = true
            
            self.gliderSprite.childNode(withName: "gliderTrail")?.run(SKAction.fadeOut(withDuration: 0.15))

            self.gliderSprite.physicsBody?.categoryBitMask    = 0x0
            self.gliderSprite.physicsBody?.collisionBitMask   = 0x0
            self.gliderSprite.physicsBody?.contactTestBitMask = 0x0
            
            var scaleUp:   SKAction,
                scaleDown: SKAction,
                ascend:    SKAction,
                descend:   SKAction,
                wait:      SKAction
            
//            if (player.getScore() > 24) {
//                scaleUp     = SKAction.scale(by: 4.0, duration: 0.65)
//                scaleDown   = SKAction.scale(by: 0.25, duration: 0.65)
//                ascend      = SKAction.animate(with: gliderTextureArray, timePerFrame: 0.18, resize: false, restore: false)
//                wait        = SKAction.wait(forDuration: 0.18)
//                descend     = SKAction.animate(with: gliderTextureArray.reversed(), timePerFrame: 0.18, resize: false, restore: false)
//            }
//            else {
            let durationUp   = player.playerState.playerJumpState.durationUp
            let durationDown = player.playerState.playerJumpState.durationDown
            let timePerFrame = player.playerState.playerJumpState.timePerFrame
            let waitDuration = player.playerState.playerJumpState.waitDuration
            
                scaleUp     = SKAction.scale(by: 4.0, duration: durationUp)
                scaleDown   = SKAction.scale(by: 0.25, duration: durationDown)
                ascend      = SKAction.animate(with: gliderTextureArray, timePerFrame: timePerFrame, resize: false, restore: false)
                wait        = SKAction.wait(forDuration: waitDuration)
                descend     = SKAction.animate(with: gliderTextureArray.reversed(), timePerFrame: timePerFrame, resize: false, restore: false)
//            }
            
            
            self.gliderSprite.run(SKAction.group([scaleUp, ascend, wait]))
            self.gliderSprite.run(SKAction.group([scaleDown, descend]), completion: {

                self.gliderSprite.childNode(withName: "gliderTrail")?.run(SKAction.fadeIn(withDuration: 0.15))
                
                self.gliderSprite.physicsBody?.categoryBitMask    = 0x2
                self.gliderSprite.physicsBody?.collisionBitMask   = 0x1
                self.gliderSprite.physicsBody?.contactTestBitMask = 0x1
                self.animationIsInProgress = false
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let position = touch.location(in: self)
            let node     = self.atPoint(position)
            
            if node.name == "continueLabel" {
                
//                avqPlayer.pause()

                var removeEnemyArray = [SKNode]()
                self.enumerateChildNodes(withName: "enemy") { (node:SKNode, nil) in

                    if let current = node as? Enemy {
                        removeEnemyArray.append(current)
                    }
                }
            
                if (self.gameViewController.showGoogleAd(forScene: self)) {
                    
                    self.removeChildren(in: removeEnemyArray)
                    self.removeChildren(in: [gliderSprite])
                    gliderSprite = createGlider()
                    self.addChild(gliderSprite)
                    self.pop.isHidden    = true
                }
                else { gameOver() }//this should later bring up another pop up saying not connected to the internet
                
            }
                
            else if node.name == "noThanksLabel" {
                
               gameOver()
            }
        }
    }
    
    func gameOver() {
        
        self.scene?.isPaused = false
        self.pop.isHidden    = true
        self.player.playerIsDead()
        avqPlayer = nil
        
        //This does not get processed until after the touches began function finishes running.
        UserDefaults.standard.set(self.player.getLifeCount(), forKey: "ExtraLifeCount")
        UserDefaults.standard.set(self.player.getHighScore(), forKey: "HighScore")
        gameOverScene.userData?.setValue(self.player.getScore(), forKey: "Score")
        gameOverScene.userData?.setValue(self.player.getHighScore(), forKey: "HighScore")
        gameOverScene.userData?.setValue(player.wasHighScoreBeaten(), forKey: "WasHighScoreBeaten")
        
        // Let sprite animation go to right or left depending on score to make it seem random.
        if (self.player.getScore() % 2 == 0) {
            let rotateGlider:SKAction = SKAction.rotate(byAngle: 10.0, duration: 1)
            gliderSprite.removeAllChildren()
            gliderSprite.physicsBody?.velocity = CGVector(dx: 200.0, dy: -200.0)
            
            self.gliderSprite.run(rotateGlider, completion: {
                let transitionScene: SKTransition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(self.gameOverScene, transition: transitionScene)
            })
            
        }
        else {
            let rotateGlider:SKAction = SKAction.rotate(byAngle: -10.0, duration: 1)
            self.gliderSprite.removeAllChildren()
            self.gliderSprite.physicsBody?.velocity = CGVector(dx: -200.0, dy: -200.0)
            
            self.gliderSprite.run(rotateGlider, completion: {
                let transitionScene: SKTransition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(self.gameOverScene, transition: transitionScene)
            })
        }
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
    
    func createGlider()->SKSpriteNode {
        
        //Position the player's glider on the screen, assign color, and set zPosition
        let gliderTexture:SKTexture      = SKTexture(imageNamed: "gliderSprite.png")
        let gliderSpriteCategory: UInt32 = 0x1 << 1
        
        let glider = SKSpriteNode(texture: gliderTexture)
        glider.physicsBody = SKPhysicsBody(texture: gliderTexture, size: CGSize(width: glider.size.width/2, height: glider.size.height/2))
        
        glider.physicsBody?.categoryBitMask    = gliderSpriteCategory
        glider.physicsBody?.collisionBitMask   = 0x1
        glider.physicsBody?.contactTestBitMask = 0x1
        
        glider.position  = CGPoint(x: sceneWidth/2.0, y: 200.0)
        glider.zPosition = 6.0
        
        let gliderTrail       = SKEmitterNode(fileNamed: "GliderTrail")!
        gliderTrail.name      = "gliderTrail"
        gliderTrail.position  = CGPoint(x: 0.0, y: -glider.size.height/2.0)
        gliderTrail.zPosition = (glider.zPosition - 1)
        
        glider.addChild(gliderTrail)
        
        return glider
    }
    
    func spawnEnemySprite(with speed: CGFloat) -> SKSpriteNode {
        
        let enemySprite:Enemy = Enemy(texture: self.enemyTexture, color: SKColor.clear, size: CGSize(width: 75, height: 75))
        enemySprite.speed     = speed
        enemySprite.name      = "enemy"
        enemySprite.position  = CGPoint(x: sceneWidth/2.0, y: sceneHeight + enemySprite.frame.height)
        enemySprite.zPosition = 5
        
//        let animateEnemy:SKAction  = SKAction.repeatForever(SKAction.animate(with: self.enemyTextureArray, timePerFrame: 0.15))
        let enemyMovement:SKAction = SKAction.moveTo(y: -sceneHeight, duration: 6.0)
        
//        enemySprite.run(SKAction.group([animateEnemy, enemyMovement]))
        enemySprite.run(enemyMovement)
        
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
        
        var spawnCloud = arc4random_uniform(20) + 1
        var spawnStar  = arc4random_uniform(20) + 1
        
        if spawnCloud >= 1 && spawnCloud <= 10 {
            
            spawnCloud = UInt32(spawnCloud) & 1
            
            let cloud      = SKSpriteNode(imageNamed: cloudImages[Int(spawnCloud)])
            cloud.name     = "cloud"
            cloud.speed    = ((2.0 * CGFloat(spawnCloud)) + 1.0) - 0.25
            let xSpawn     = CGFloat(arc4random_uniform(UInt32(self.sceneWidth)))
            let move       = SKAction.moveTo(y: -self.sceneHeight, duration: 15.0)
            cloud.position = CGPoint(x: xSpawn, y: self.sceneHeight + frame.height/2.0)
            
            cloud.run(move)

            self.addChild(cloud)
        }
        
        if spawnStar >= 1 && spawnStar <= 10 {
            
            let starSpeed           = UInt32(spawnStar) & 1
            let starScaleIndex      = UInt32(spawnStar) & 1
            spawnStar               = UInt32(spawnStar) % 19
            let scaleArr:[CGFloat]  = [0.15,0.25]
            let scaledSize:CGFloat  = scaleArr[Int(starScaleIndex)]
            let xSpawn              = CGFloat(arc4random_uniform(UInt32(self.sceneWidth)))
            
            let star   = StarSprite(scale: scaledSize)
            star.name  = "star"
            star.speed = ((2.0 * CGFloat(starSpeed)) + 1.0) - 0.25
            
            let move      = SKAction.moveTo(y: -self.sceneHeight, duration: 15.0)
            star.position = CGPoint(x: xSpawn, y: self.sceneHeight + frame.height/2.0)
            
            star.run(move)
            self.addChild(star)
        }
    }
    
    
    func checkForScoreUpdates() {
        
        self.enumerateChildNodes(withName: "enemy") { (node:SKNode, nil) in
            //will need to make this a different loop so that Enemy can be used.
            if let current = node as? Enemy {
                
                if !self.player.hasPlayerDied() {
                    
                    if (current.position.y < self.gliderSprite.position.y) && (!current.hasBeenScored()) {
                        self.player.updateScore()
                        self.player.updateLifeCount()
                        self.updateScoreLabel()
                        current.setEnemyAsScored()
                    }
                    
                    if node.position.y < (0 - node.frame.size.height * 2.0) {
                        node.removeFromParent()
                    }
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
        
        self.scoreLbl.text  = "\(self.player.getScore())"
        self.extraLife.text = "\(self.player.getLifeCount())/500" //prints parentheses
        
        self.scoreLbl.animateScore()
    }
    
    func toggleAVPlayerState() {
        if avqPlayer.isMuted {
            avqPlayer.isMuted = false
        }
        else{ avqPlayer.isMuted = true }
    }
        
}
