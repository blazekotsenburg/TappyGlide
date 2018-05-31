//
//  StarSprite.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 1/20/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit

class StarSprite: SKSpriteNode {
    
    init(scale: CGFloat) {
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 10, height: 10))
        
        let up    = SKEmitterNode(fileNamed: "StarUp")!
        let right = SKEmitterNode(fileNamed: "StarRight")!
        let down  = SKEmitterNode(fileNamed: "StarDown")!
        let left  = SKEmitterNode(fileNamed: "StarLeft")!
        
        let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        up.position    = center
        right.position = center
        down.position  = center
        left.position  = center
        
        up.setScale(scale)
        right.setScale(scale)
        down.setScale(scale)
        left.setScale(scale)
        
        self.addChild(up)
        self.addChild(right)
        self.addChild(down)
        self.addChild(left)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
