//
//  PopUpNode.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 7/8/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit

class PopUpNode : SKSpriteNode {
    
    private var continueButton: SKSpriteNode!
    private var label:          SKLabelNode!
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.zPosition = 10
        
        label = SKLabelNode(text: "Watch an ad to continue?")
        label.position = CGPoint(x: 0, y: size.height*0.25)
        label.fontColor = UIColor.black
        label.fontSize = 45
        self.addChild(label)
        
        continueButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100))
        continueButton?.position = CGPoint(x: 0, y: -size.height*0.25)
        continueButton.name = "continueButton"
        self.addChild(continueButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
