//
//  SKScoreLabel.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 1/10/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit

class SKScoreLabel: SKLabelNode {
    
    init(at position: CGPoint, with text: String?) {
        super.init()
        
        self.text      = text
        self.color     = UIColor(ciColor: CIColor(rgba: "#DDDDDD"))
        self.alpha     = 0.5
        self.fontName  = "Avenir"
        self.zPosition = -5
        self.position  = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSize(with size: CGFloat) {
        self.fontSize = size;
    }
    
    func animateScore() {
        
        let sequenceUp = SKAction.sequence([SKAction.run {
            self.setScale(1.15)
            self.position.y += 10
        }, SKAction.wait(forDuration: 0.25)])
        
        self.run(sequenceUp)
        
        let sequenceDown = SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.run {
            self.setScale(1.0)
            self.position.y -= 10
        }])
        
        self.run(sequenceDown)
    }
}
