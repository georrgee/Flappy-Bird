//
//  GameScene.swift
//  Flappy Bird
//
//  Created by George Garcia on 8/7/17.
//  Copyright © 2017 George. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    //create our bird sprite. Access our bird sprite from several locations
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 { // 32 bit Integer
        
        case Bird = 1
        case Object = 2
        case Gap = 4
        
    }
    
    var gameOver = false
    var gameOverLabel = SKLabelNode()
    
    var timer = Timer()
    var score = 0
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        setUpGame()
        
    }
    
    
    func setUpGame(){
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        //ADDING BACKGROUND
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        // background going left to right (endless loop)
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 9)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0.5)
        
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(moveBGForever)
            
            bg.zPosition = -2
            
            self.addChild(bg)
            
            i += 1
        }
        
        //ADD FLAPPY BIRD TO THE SCREEN. FLAPPY1.png to FLAPPY2.png
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        bird = SKSpriteNode(texture: birdTexture2)
        
        // SETTING UP ANIMATION FOR THE BIRD
        let animation = SKAction.animate(with: [birdTexture,birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        // APPLY ANIMATION TO OUR BIRD
        bird.run(makeBirdFlap)
        
        // PHYSICS FOR THE BIRD
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2) // circle around the bird
        bird.physicsBody!.isDynamic = false
        
        
        // Assigning ENUM
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue // collisionBitMask; allows you to make clear whether two objects allow to pass through each other or not
        
        //add the bird to the view controller
        self.addChild(bird)
        
        // ADDING THE GROUND NODE
        let ground = SKNode() // jsut an invisible object
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2) // take it to the bottom of the screen
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false // ground does not move. does not effect gravity
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70) // top of the screen
        
        self.addChild(scoreLabel)
        
    }

    @objc func makePipes() {
        
        // ADDING PIPES
        
        // animation for pipes
        let movingPipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movingPipes, removePipes])
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2) // total amount of the pipes that is gonna move up or down
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        
        
        let gapHeight = bird.size.height * 4
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset)
        pipe1.run(movingPipes)
        
        // creating physics body for PIPES
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        
        
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        pipe1.zPosition = -1
        
        self.addChild(pipe1)
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture2.size().height / 2 - gapHeight / 2 + pipeOffset)
        pipe2.run(movingPipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        pipe2.zPosition = -1
        
        self.addChild(pipe2)
        
        
        // GAP between PIPES FOR SCORING
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        
        gap.physicsBody!.isDynamic = false
        
        gap.run(moveAndRemovePipes)
        
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        self.addChild(gap)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // method will be called when the objects have contact between objects
        
        if gameOver == false {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue{
            
            print("Add one to score")
            
            score += 1
            scoreLabel.text = String(score)
            
        } else{
        
            print("Contact!")
            self.speed = 0 // Stop everything from happening
            gameOver = true
            
            timer.invalidate()
            
            gameOverLabel.fontName = "Helvetica"
            gameOverLabel.fontSize = 30
            gameOverLabel.text = "Game Over! Tap to play again!"
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
        }
     }
  }
    
    // need this
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
        
            bird.physicsBody!.isDynamic = true
            
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 60))
        
        } else{ // restarting game
            
            gameOver = false
            score = 0
            self.speed = 1 // go back to normal speed
            self.removeAllChildren()
            setUpGame()
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
    }
}
