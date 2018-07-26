//
//  Model.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 1/8/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import SpriteKit

class Player {
    private var score:          Int
    private var highScore:      Int
    private var extraLifeCount: Int
    private var highScoreBeat:  Bool
    private var hasExtraLife:   Bool
    private var isPlayerDead:   Bool
    
    var isNewTurn:              Bool
    var index:                  Int
    
    var speedAndSpawns: [(CGFloat, UInt32)] //Speed, Interval
    
    init() {

        score          = 0
        highScore      = 0
        extraLifeCount = 0
        index          = 0
        
        highScoreBeat  = false
        hasExtraLife   = false
        isPlayerDead   = false
        isNewTurn      = true
        
        speedAndSpawns = [(1.0, 7), (1.15, 6), (1.25, 5), (1.45, 4), (1.65, 2)]
    }
    
    func getScore() -> Int {
        return score
    }
    
    func setScore(newScore: Int) {
        score = newScore
    }
    
    func updateScore() {
        score += 1
        if score > highScore {
            highScoreBeat = true
            updateHighScore(newHighScore: score)
        }
    }
    
    func updateLifeCount() {
        extraLifeCount += 1
        
        if (extraLifeCount >= 500) {
            extraLifeCount = 0
            hasExtraLife   = true
        }
    }
    
    func getHighScore()->Int {
        return highScore
    }
    
    func updateHighScore(newHighScore: Int) {
        highScore = newHighScore
    }
    
    func wasHighScoreBeaten()->Bool {
        return highScoreBeat
    }
    
    func getLifeCount() -> Int {
        return extraLifeCount
    }
    
    func setLifeCount(score: Int) {
        extraLifeCount = score
    }
    
    func hasPlayerDied() -> Bool{
        return isPlayerDead
    }
    
    func playerIsDead() {
        isPlayerDead = true
    }
}
