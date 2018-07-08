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
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        scored = false
        super.init(texture: texture, color: SKColor.clear, size: size)

        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        self.physicsBody?.categoryBitMask = enemySpriteCategory
        self.physicsBody?.affectedByGravity = false
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
