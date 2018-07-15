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

class GameViewController: UIViewController {

    let userDefaults: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
