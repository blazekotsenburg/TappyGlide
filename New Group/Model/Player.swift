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
    
    var playerState:            PlayerState
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
        
        func peek()->TimeInterval{
            return list[0]
        }
    }
    
    var speedAndSpawns: [(CGFloat, UInt32)] //Speed, Interval
    
    struct PlayerState {
        
        struct EnemySpeedAndSpawnSettings {
            var max:     UInt32
            var min:     UInt32
            var divisor: Double
        }
        
        struct playerJumpSettings {
            var durationUp:   TimeInterval
            var durationDown: TimeInterval
            var timePerFrame: TimeInterval
            var waitDuration: TimeInterval
        }
        
        var enemySpeedAndSpawnSettings: EnemySpeedAndSpawnSettings
        var playerJumpState:            playerJumpSettings
        
        init() {
            enemySpeedAndSpawnSettings = EnemySpeedAndSpawnSettings(max: 5, min: 3, divisor: 5.0)
            playerJumpState = playerJumpSettings(durationUp: 0.65, durationDown: 0.65, timePerFrame: 0.162, waitDuration: 0.0005)
        }
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
        
        playerState    = PlayerState()
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
                playerState.enemySpeedAndSpawnSettings.max = 4 //will set interval between 1.4 and 0.6 when used in generateSpawnIntervalsInQueue()
            break
            case 16 ..< 24:
                playerState.enemySpeedAndSpawnSettings.max = 3 //will set interval between 1.2 and 0.6 when used in generateSpawnIntervalsInQueue()
            break
            case 24 ..< 32:
                playerState.enemySpeedAndSpawnSettings.max = 2
//                playerState.enemySpeedAndSpawnSettings.min = 2
            break
            case let x where x >= 32:
                playerState.enemySpeedAndSpawnSettings.max = 3
            break
            default:
            break
        }
    }
    
    func updateLifeCount() {
        extraLifeCount += 1
        
        if (extraLifeCount > 499) {
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
    
    func hasAnExtraLife()->Bool {
        return hasExtraLife
    }
    
    func resetExtraLife() {
        hasExtraLife = false
    }
    
    func hasPlayerDied() -> Bool{
        return isPlayerDead
    }
    
    func playerIsDead() {
        isPlayerDead = true
    }
    
    func generateSpawnIntervalsInQueue() {
        
        let max     = playerState.enemySpeedAndSpawnSettings.max
        let min     = playerState.enemySpeedAndSpawnSettings.min
        let divisor = playerState.enemySpeedAndSpawnSettings.divisor
        
        switch score {
            
            case 0 ..< 8:
                for _ in 0 ..< 8 {
                    var newInterval = TimeInterval(arc4random_uniform(max) + min) / divisor
                    if !queue.list.isEmpty {
                        if (queue.list.last! - newInterval <= 0.2) {
                            newInterval += 0.12
                        }
                    }
                    queue.enqueue(item: newInterval)
                }
            break
            
            case 8 ..< 16:
                for _ in 0 ..< 8 {
                    var newInterval = TimeInterval(arc4random_uniform(max) + min) / divisor
                    if (queue.list.last! - newInterval <= 0.2) {
                        newInterval += 0.15
                    }
                    queue.enqueue(item: newInterval)
                }
            break
            
            case 16 ..< 24:
                for _ in 0 ..< 8 {
                    var newInterval = TimeInterval(arc4random_uniform(max) + min) / divisor
                    if (abs(queue.list.last! - newInterval) <= 0.2) {
                        newInterval += 0.15
                    }
                    queue.enqueue(item: newInterval)
                }
            break
            
            case 24 ..< 32:
                for _ in 0 ..< 8 {
                    var newInterval = TimeInterval(arc4random_uniform(max) + min) / divisor
                    if (abs(queue.list.last! - newInterval) <= 0.2) {
                        newInterval += 0.15
                    }
                    
                    queue.enqueue(item: newInterval)
                }
            break
            
            default:
                for _ in 0 ..< 50 {
                    var newInterval = TimeInterval(arc4random_uniform(max) + min) / 6
                    if queue.list.last! - newInterval <= 0.2 {
                        newInterval += 0.2
                    }
                    queue.enqueue(item: newInterval)
                }
            break
        }
        
        }
    
    func getIntervalFromQueue()->TimeInterval {
        
        if queue.list.count <= 3 {
            self.generateSpawnIntervalsInQueue()
        }
        
        return queue.dequeue()
    }
    
    func peekQueue()->TimeInterval {
        return queue.peek()
    }
}
