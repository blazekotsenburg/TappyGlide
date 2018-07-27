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
    private var queue:          Queue
    private var ssSettings:     SpeedAndSpawnSettings
    
    var isNewTurn:              Bool
    var index:                  Int
    
    private struct Queue {
        var list: [TimeInterval] = [TimeInterval]()
        
        mutating func enqueue(item: TimeInterval) {
            list.append(item)
        }
        
        mutating func dequeue()->TimeInterval {
            if !list.isEmpty {
                return list.removeFirst()
            }
            else { return 0 }
        }
    }
    
    var speedAndSpawns: [(CGFloat, UInt32)] //Speed, Interval
    
    struct SpeedAndSpawnSettings {
        var max:     UInt32
        var min:     UInt32
        var divisor: Double
    }
    
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
        queue          = Queue()
        ssSettings     = SpeedAndSpawnSettings(max: 6, min: 3, divisor: 5.0)
        self.generateSpawnIntervalsInQueue()
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
        
        switch score {
            case 8 ..< 16:
                ssSettings.max = 5 //will set interval between 1.6 and 0.6 when used in generateSpawnIntervalsInQueue()
            break
            case 16 ..< 24:
                ssSettings.max = 4 //will set interval between 1.4 and 0.6 when used in generateSpawnIntervalsInQueue()
            break
            case 24 ..< 32:
                ssSettings.max = 3
            break
            case let x where x >= 32:
                ssSettings.max = 2
            break
            default:
            break
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
    
    func generateSpawnIntervalsInQueue() {
        
        for _ in 0 ..< 50 {
            let newInterval = TimeInterval(arc4random_uniform(ssSettings.max) + ssSettings.min) / ssSettings.divisor
            queue.enqueue(item: newInterval)
        }
    }
    
    func getIntervalFromQueue()->TimeInterval {
        
        if queue.list.count < 15 {
            self.generateSpawnIntervalsInQueue()
        }
        
        return queue.dequeue()
    }
    
    func peekQueue()->TimeInterval {
        return queue.list[0]
    }
}
