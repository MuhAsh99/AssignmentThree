
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
    // Ball
    let ballSprite = SKSpriteNode(imageNamed: "bball")
    
    // Retry buttons
    let spendButton = SKButton()
    let noButton = SKButton()
    
    //label for scoring and lose declaration
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    let loseLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    //creating game score var
    var gameScore:Int = 0{
        willSet(newValue){
            DispatchQueue.main.async {
                //score will update the label
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
    }
    
    // Track available steps to spend
    var stepsAvailable:Int = availableSteps{
        willSet(newValue){
            DispatchQueue.main.async {
                //score will update the label
                self.loseLabel.text = "You lost. Spend 30 steps to keep score going? Available Steps: \(self.stepsAvailable)"
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
        
        // Add world
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.black
        
        self.startMotionUpdates()
        
        //add paddles
        self.addPaddle1(CGPoint(x: size.width*0.5, y: size.height*0.07))
        self.addPaddle2(CGPoint(x: size.width*0.1, y: size.height*0.85))
        //add ball
        self.addBall()
        // Add score
        self.addScore()
        // Add Walls
        self.addSides()
        // Add Loss UI items
        self.addLoseLabel()
        self.addButtons()
        
    }
    
    // Make paddles follow player and prevent them from entering goals
    // Check for player in goal and reward score
    override func update(_ currentTime: TimeInterval) {
        paddle1.run(SKAction.moveTo(x: self.ballSprite.position.x, duration:0.9))
        paddle2.run(SKAction.moveTo(x: self.ballSprite.position.x, duration: 0.9))
        
        if ballSprite.position.y < 0  || ballSprite.position.y > size.height-ballSprite.size.height {
            self.gameScore += 10
            resetBall()
            
        }
    }
    
    // Setup and add player object
    func addBall(){
        // setup size and physics body
        ballSprite.size = CGSize(width: size.width*0.1, height: size.height*0.05)
        
        ballSprite.position = CGPoint(x: size.width/2 - ballSprite.size.width, y: size.height/2 - ballSprite.size.height)

        ballSprite.physicsBody = SKPhysicsBody(rectangleOf:ballSprite.size)

        ballSprite.physicsBody?.restitution = 0.8

        ballSprite.physicsBody?.isDynamic = true
        // for collision detection we need to setup these masks
        ballSprite.physicsBody?.contactTestBitMask = 0x00000001
        ballSprite.physicsBody?.collisionBitMask = 0x00000001
        ballSprite.physicsBody?.categoryBitMask = 0x00000001

        self.addChild(ballSprite)


    }
    
    // Reset ball to inital position
    func resetBall() {
        ballSprite.position = CGPoint(x: size.width/2 - ballSprite.size.width, y: size.height/2 - ballSprite.size.height)
    }
    
    // Add score label at bottom
    func addScore(){
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.green
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.minY+20)
        
        addChild(scoreLabel)
    }
    
    // Add text for loss state, not initially visible
    func addLoseLabel() {
        loseLabel.text = "You lost. Spend 30 steps to keep score going? Available Steps: \(stepsAvailable)"
        loseLabel.fontSize = 13
        loseLabel.fontColor = SKColor.white
        loseLabel.preferredMaxLayoutWidth = size.width/2+size.width/4
        loseLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        loseLabel.alpha = 0
        loseLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        loseLabel.numberOfLines = 0
        loseLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        addChild(loseLabel)
    }
    
    // Add buttons for loss state to Scene, not initially visible
    func addButtons() {
        spendButton.text = "Yes"
        spendButton.fontSize = 20
        spendButton.fontColor = SKColor.white
        spendButton.position = CGPoint(x: frame.midX + 30, y: frame.midY-90)
        spendButton.alpha = 0
        spendButton.isUserInteractionEnabled = true
        
        
        noButton.text = "No"
        noButton.fontSize = 20
        noButton.fontColor = SKColor.white
        noButton.position = CGPoint(x: frame.midX - 30, y: frame.midY-90)
        noButton.alpha = 0
        noButton.isUserInteractionEnabled = true
        
        addChild(spendButton)
        addChild(noButton)
    }

    // Setup and add Paddle1 to Scene
    func addPaddle1(_ point:CGPoint){
        
        paddle1.color = UIColor.red
        paddle1.size = CGSize(width:size.width*0.17,height:size.height * 0.05)
        paddle1.position = point
        
        paddle1.physicsBody = SKPhysicsBody(rectangleOf:paddle1.size)
        paddle1.physicsBody?.contactTestBitMask = 0x00000001
        paddle1.physicsBody?.collisionBitMask = 0x00000001
        paddle1.physicsBody?.categoryBitMask = 0x00000001
        paddle1.physicsBody?.isDynamic = false
        paddle1.physicsBody?.pinned = false
        paddle1.physicsBody?.allowsRotation = false
            
        self.addChild(paddle1)
        
    }
    
    // Setup and add Paddle2 to Scene
    func addPaddle2(_ point:CGPoint){
        paddle2.color = UIColor.red
        paddle2.size = CGSize(width:size.width*0.17,height:size.height * 0.05)
        paddle2.position = point
        
        paddle2.physicsBody = SKPhysicsBody(rectangleOf:paddle2.size)
        paddle2.physicsBody?.contactTestBitMask = 0x00000001
        paddle2.physicsBody?.collisionBitMask = 0x00000001
        paddle2.physicsBody?.categoryBitMask = 0x00000001
        paddle2.physicsBody?.isDynamic = false
        paddle2.physicsBody?.pinned = false
        paddle2.physicsBody?.allowsRotation = false
            
        self.addChild(paddle2)
    }
    
    func addSides(){
        //func for side walls
        let leftSide = SKSpriteNode()
        let rightSide = SKSpriteNode()

        //only need sides so that ball can bounce off of them
        leftSide.size = CGSize(width: size.width*0.01, height: size.height)
        leftSide.position = CGPoint(x: -size.width*0.01, y: size.height*0.5)

        rightSide.size = CGSize(width: size.width*0.1, height: size.height)
        rightSide.position = CGPoint(x: size.width, y: size.height*0.5)

        for obj in [leftSide,rightSide]{
            obj.alpha = 0
            obj.physicsBody = SKPhysicsBody(rectangleOf:obj.size)
            obj.physicsBody?.isDynamic = true
            obj.physicsBody?.pinned = true
            obj.physicsBody?.allowsRotation = false
            self.addChild(obj)
        }

    }
    
    //function that makes the user lose if they touch the paddles
    // Allows them to retry and keep score if they spend steps
    // Unhides and rehides lose state ui elements and resets ball
    func didBegin(_ contact: SKPhysicsContact){
        if (contact.bodyA.node == paddle1 || contact.bodyB.node == paddle1)
            || (contact.bodyA.node == paddle2 || contact.bodyB.node == paddle2) {
            loseLabel.alpha = 1
            spendButton.alpha = 1
            noButton.alpha = 1
            
            
            ballSprite.physicsBody?.isDynamic = false
            
            spendButton.touchEndedCallback = {
                if self.stepsAvailable >= 30 {
                    self.stepsAvailable -= 30
                } else {
                    self.gameScore = 0
                }
                self.loseLabel.alpha = 0
                self.spendButton.alpha = 0
                self.noButton.alpha = 0
                self.spendButton.touchEndedCallback = {}
                self.ballSprite.physicsBody?.isDynamic = true
                self.resetBall()
            }
            
            noButton.touchEndedCallback = {
                self.gameScore = 0
                self.loseLabel.alpha = 0
                self.spendButton.alpha = 0
                self.noButton.alpha = 0
                self.noButton.touchEndedCallback = {}
                self.ballSprite.physicsBody?.isDynamic = true
                self.resetBall()
            }
        }
    }
}
