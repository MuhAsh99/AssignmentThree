
//  PongGameScene.swift
//  AssignmentThree
//
//  Created by Muhammad Ashraf on 10/22/22.


import UIKit
import SpriteKit
import CoreMotion

class PongGameScene: SKScene, SKPhysicsContactDelegate {
    
    //creating paddles for pong game
    let paddle1 = SKSpriteNode()
    let paddle2 = SKSpriteNode()
    
    //label for scoring
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    //creating game score var
    var gameScore:Int = 0{
        willSet(newValue){
            DispatchQueue.main.async {
                //score will update the label
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    
    func addBall(){
        let ballSprite = SKSpriteNode(imageNamed: <#T##String#>)
    }
    
    

}
