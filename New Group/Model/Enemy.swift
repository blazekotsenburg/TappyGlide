//
//  Enemy.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 1/9/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    private var scored: Bool!
    private let enemySpriteCategory: UInt32 = 0x1
    
//    init(circleOfRadius: Double, at point: CGPoint) {
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        scored = false
        super.init(texture: texture, color: SKColor.clear, size: size)
        
//        let myPath = CGMutablePath()
//        CGPathAddArc( myPath, nil, 0,0, 15, 0, CGFloat( M_PI * 2.0 ), true )
//        path = myPath
        
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        self.physicsBody?.categoryBitMask = enemySpriteCategory
        self.physicsBody?.affectedByGravity = false
//        self.fillColor = UIColor(red: 224.0/225.0, green: 2.0/255.0, blue: 128.0/255.0, alpha: 1.0)
//        self.strokeColor = UIColor.red
//        self.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
//        self.physicsBody?.categoryBitMask = enemySpriteCategory
//        self.physicsBody?.affectedByGravity = false
//        self.zPosition = 6.0 //will need to change this to same position as the glider later on.
//        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -25, y: 0), size: CGSize(width: 25.0 * 2, height: 25.0 * 2)), transform: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hasBeenScored() -> Bool {
        return scored
    }
    
    func setEnemyAsScored() {
        scored = true
    }
    
    func updateSpeed(with newSpeed: Double, to yPosition: CGFloat) {
        
        let newAction = SKAction.moveTo(y: yPosition, duration: newSpeed)
        newAction.timingMode = .linear
        self.run(newAction)
    }
}
