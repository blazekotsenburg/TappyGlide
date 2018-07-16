//
//  GameViewController.swift
//  tappy-glide
//
//  Created by Blaze Kotsenburg on 1/4/18.
//  Copyright © 2018 Blaze Kotsenburg. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADRewardBasedVideoAdDelegate {

    private var userDefaults:  UserDefaults!
    private var rewardBasedAd: GADRewardBasedVideoAd!
    private var viewedFullAd:  Bool!
    private var gameScene:     GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults = UserDefaults.standard
        viewedFullAd = false
        
        rewardBasedAd          = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        
        if !(isKeyPresentInUserDefaults(key: "ExtraLifeCount") &&
             isKeyPresentInUserDefaults(key: "HighScore")) {
            
            userDefaults.setValue(0,     forKey: "ExtraLifeCount")
            userDefaults.setValue(0,     forKey: "HighScore")
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let startScene = SKScene(fileNamed: "StartScene") {
                // Set the scale mode to scale to fit the window
                startScene.scaleMode = .aspectFill
                // Present the startScene
                view.presentScene(startScene)
            }
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
        }

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func loadGoogleAd() {
        
        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    
    func showGoogleAd(forScene: SKScene) {
        
        if rewardBasedAd.isReady {
            rewardBasedAd.present(fromRootViewController: self)
            gameScene = forScene as? GameScene
        }
    }
    
    func wasFullAddViewd()->Bool{
        
        if viewedFullAd{
            viewedFullAd = false
            return true
        }
        else {
         
            return false
        }
    }
    
    /********************* GADRewardBasedVideoAdDelegat required funcs *********************/
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        viewedFullAd = true
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        if viewedFullAd {
            viewedFullAd = false
        }
        gameScene?.isPaused = false
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
}
