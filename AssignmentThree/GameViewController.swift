//
//  GameViewController.swift
//  AssignmentThree
//
//  Created by Muhammad Ashraf on 10/22/22.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //setting up the game scene
        let gameScene = PongGameScene(size: view.bounds.size)
        let skView = view as! SKView // the view in storyboard must be an SKView
        skView.showsFPS = true // show some debugging of the FPS
        skView.showsNodeCount = true // show how many active objects are in the scene
        skView.ignoresSiblingOrder = true // don't track who entered scene first
        gameScene.scaleMode = .resizeFill
        skView.presentScene(gameScene)
    
    }





}
