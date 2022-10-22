
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
    
    //allows us to set gravity so that user can move the ball around
    let motion = CMMotionManager()
        func startMotionUpdates(){
            
        if self.motion.isDeviceMotionAvailable{
                self.motion.deviceMotionUpdateInterval = 0.1
                self.motion.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: self.handleMotion )
            }
        }
        
        func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
                if let gravity = motionData?.gravity {
                self.physicsWorld.gravity = CGVector(dx: CGFloat(9.8*gravity.x), dy: CGFloat(9.8*gravity.y))
            }
        }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.black
        
        self.startMotionUpdates()
        
        //adds border around screen for ball to bounce around
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        //add paddles
        self.addPaddle1(CGPoint(x: size.width*0.5, y: size.height*0.35))
        self.addPaddle2(CGPoint(x: size.width*0.1, y: size.height*0.65))
        
        //add ball
       // self.addBall()

        
    }
    
    //***this function is supposed to have the paddles move along with the ball but with a delay
    override func update(_ currentTime: TimeInterval) {
        paddle1.run(SKAction.moveTo(x: self.addBall().position.x, duration: 0.2))
        paddle2.run(SKAction.moveTo(x: self.addBall().position.x, duration: 0.2))
    }
    
    //***
    func addBall(){
        //setting sprite to image in assets file
        let ballSprite = SKSpriteNode(imageNamed: "bball")

        ballSprite.size = CGSize(width: size.width*0.1, height: size.height*0.1)

        //SIMON this is from the profs slides but im not sure why it isnt working, maybe you can figure out a way how
       // let randNumber = random(min: (0.1), max: CGFloat(0.9))

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
    
    func addScore(){
            
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.green
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY)
        
        addChild(scoreLabel)
        
        }

    func addPaddle1(_ point:CGPoint){
        
        paddle1.color = UIColor.red
        paddle1.size = CGSize(width:size.width*0.15,height:size.height * 0.05)
        paddle1.position = point
        
        paddle1.physicsBody = SKPhysicsBody(rectangleOf:paddle1.size)
        paddle1.physicsBody?.contactTestBitMask = 0x00000001
        paddle1.physicsBody?.collisionBitMask = 0x00000001
        paddle1.physicsBody?.categoryBitMask = 0x00000001
        paddle1.physicsBody?.isDynamic = true
        paddle1.physicsBody?.pinned = true
            
        self.addChild(paddle1)
        
    }
    
    func addPaddle2(_ point:CGPoint){
        paddle2.color = UIColor.red
        paddle2.size = CGSize(width:size.width*0.15,height:size.height * 0.05)
        paddle2.position = point
        
        paddle2.physicsBody = SKPhysicsBody(rectangleOf:paddle2.size)
        paddle2.physicsBody?.contactTestBitMask = 0x00000001
        paddle2.physicsBody?.collisionBitMask = 0x00000001
        paddle2.physicsBody?.categoryBitMask = 0x00000001
        paddle2.physicsBody?.isDynamic = true
        paddle2.physicsBody?.pinned = true
            
        self.addChild(paddle2)
    }
    
    //***maybe this is a better way to handle the borders for the game but I am not sure
    //in didMove func above i added a border variable that could serve the same purpose as this function below
    //just not sure which route we want to take
    
    func addSides(){
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
    
    //function that makes the user lose if they touch the paddles
    func hitPaddle(_ contact: SKPhysicsContact){
        if contact.bodyA.node == paddle1 || contact.bodyB.node == paddle2{
            //player loses
            //need tp figure out how to do this
        }
    }
    
    
    

}
