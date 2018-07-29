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
    private var clipBoardImage: SKSpriteNode!
    private var promptLabel:    SKLabelNode!
    private var continueLabel:  SKLabelNode!
    private var noThanksLabel:  SKLabelNode!
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.zPosition = 10
        self.alpha = 0.95
        
        promptLabel = SKLabelNode(text: "Watch an ad to continue?")
        promptLabel.position = CGPoint(x: 0, y: size.height*0.25)
        promptLabel.fontColor = UIColor.black
        promptLabel.fontSize = 45
        self.addChild(promptLabel)
        
        continueLabel = SKLabelNode(text: "Continue!")
        continueLabel?.position = CGPoint(x: 0, y: -size.height*0.25)
        continueLabel.fontColor = UIColor.black
        continueLabel.fontSize  = 55
        continueLabel.name = "continueLabel"
        self.addChild(continueLabel)
        
        clipBoardImage = SKSpriteNode(imageNamed: "clipBoardImage.png")
        clipBoardImage.position = CGPoint(x: 0, y: 0)
        self.addChild(clipBoardImage)
        
        noThanksLabel = SKLabelNode(text: "no thanks...")
        noThanksLabel.position = CGPoint(x: 0, y: continueLabel.position.y - 100)
        noThanksLabel.fontColor = UIColor.black
        noThanksLabel.fontSize = 35
        noThanksLabel.name = "noThanksLabel"
        self.addChild(noThanksLabel)
        
        self.isHidden = true
        
//        let buttonColor = SKColor(ciColor: CIColor(red: 0.257, green: 0.772, blue: 0.956, alpha: 1))
//        continueButton = SKSpriteNode(color: buttonColor, size: CGSize(width: 100, height: 100))
//        continueButton?.position = CGPoint(x: 0, y: -size.height*0.25)
//        continueButton.name = "continueButton"
//        self.addChild(continueButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
