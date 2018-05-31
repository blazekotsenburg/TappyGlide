//
//  Model.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 1/8/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit

class Model {
    private var score:          Int
    private var extraLifeCount: Int
    private var hasExtraLife:   Bool
    
    init() {
        
        extraLifeCount = 0
        score          = 0
        hasExtraLife   = false
    }
    
    func getScore() -> Int {
        return score
    }
    
    func setScore(newScore: Int) {
        score = newScore
    }
    
    func updateScore() {
        score += 1
    }
    
    func updateLifeCount() {
        extraLifeCount += 1
        
        if (extraLifeCount >= 500) {
            extraLifeCount = 0
            hasExtraLife   = true
        }
    }
    
    func getLifeCount() -> Int {
        return extraLifeCount
    }
}
