
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
        //setting sprite to image in assets file
        let ballSprite = SKSpriteNode(imageNamed: "bball")
        
        ballSprite.size = CGSize(width: size.width*0.1, height: size.height*0.1)
        
        //SIMON this is from the profs slides but im not sure why it isnt working, maybe you can figure out a way how
       // let randNumber = random(min: CGFloat(0.1), max: CGFloat(0.9))
        
        //SIMON this is from the profs slides but im not sure why it isnt working, maybe you can figure out a way how
       // ballSprite.position = CGPoint(x: size.width * randNumber, y: size.height * 0.75)
                
        ballSprite.physicsBody = SKPhysicsBody(rectangleOf:ballSprite.size)
        
        //SIMON this is from the profs slides but im not sure why it isnt working, maybe you can figure out a way how
       // ballSprite.physicsBody?.restitution = random(min: CGFloat(1.0), max: CGFloat(1.5))
        
        ballSprite.physicsBody?.isDynamic = true
        // for collision detection we need to setup these masks
        ballSprite.physicsBody?.contactTestBitMask = 0x00000001
        ballSprite.physicsBody?.collisionBitMask = 0x00000001
        ballSprite.physicsBody?.categoryBitMask = 0x00000001
                
        self.addChild(ballSprite)
        
        
    }
    
    func addSide(){
        //func for side walls
        let leftSide = SKSpriteNode()
        let rightSide = SKSpriteNode()
        
        //only need sides so that ball can bounce off of them
        leftSide.size = CGSize(width: size.width*0.1, height: size.height)
        leftSide.position = CGPoint(x: 0, y: size.height*0.5)
        
        rightSide.size = CGSize(width: size.width*0.1, height: size.height)
        rightSide.position = CGPoint(x: size.width*0.5, y: size.height*0.5)
        
        for obj in [leftSide,rightSide]{
                    obj.color = UIColor.white
                    obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
                    obj.physicsBody?.isDynamic = true
                    obj.physicsBody?.pinned = true
                    obj.physicsBody?.allowsRotation = false
                    self.addChild(obj)
                }
        
    }
    
    
    

}
