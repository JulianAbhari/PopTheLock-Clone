//
//  GameScene.swift
//  PopTheLock
//
//  Created by Julian Abhari on 9/24/15.
//  Copyright (c) 2015 Julian Abhari. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var Circle = SKSpriteNode()
    var Person = SKSpriteNode()
    var Dot = SKSpriteNode()
    
    var Path = UIBezierPath()
    
    var gameStarted = Bool()
    
    var movingClockWise = Bool()
    
    var intersected = false
    
    var LevelLabel = UILabel()
    
    var level = 0
    
    override func didMoveToView(view: SKView) {
        
        loadView()
        
    }
    
    func loadView(){
        backgroundColor = SKColor.blackColor()
        Circle = SKSpriteNode(imageNamed: "Circle" )
        Circle.size = CGSize(width: 300, height: 300)
        Circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(Circle)
        
        Person = SKSpriteNode(imageNamed: "Person")
        Person.size = CGSize(width: 40, height: 7)
        Person.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 130)
        Person.zRotation = 3.14 / 2
        Person.zPosition = 2.0
        Person.setScale(0.8)
        
        self.addChild(Person)
        AddDot()
        
        LevelLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        LevelLabel.center = (self.view?.center)!
        LevelLabel.text = "\(level)"
        LevelLabel.textColor = SKColor.darkGrayColor()
        self.view?.addSubview(LevelLabel)
    
    }
    
    func AddDot() {
        
        Dot = SKSpriteNode(imageNamed: "Dot")
        Dot.size = CGSize(width: 30, height: 30)
        Dot.position = CGPointMake(80, 20)
        Dot.zPosition = 1.0
        Dot.setScale(1.0)
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        if movingClockWise == true {
            let tempAngle = CGFloat.random(min: rad + 2.0, max: rad + 5.5)
            let Path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.height / 1.49, y: self.frame.height / 2.0), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            
            Dot.position = Path2.currentPoint
            
        }
        
        if movingClockWise == false {
            
            let tempAngle = CGFloat.random(min: rad - 2.0, max: rad - 5.5)
            let Path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.height / 1.49, y: self.frame.height / 2.0), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            
            Dot.position = Path2.currentPoint
            
        }
        
        self.addChild(Dot)
    }
    
    func moveClockWise() {
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2), radius: 130, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 250)
        Person.runAction(SKAction.repeatActionForever(follow).reversedAction())
        
    }
    
    func moveCounterClockWise(){
       
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2), radius: 130, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 300)
        Person.runAction(SKAction.repeatActionForever(follow))
        
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gameStarted == false {
            
            moveClockWise()
            movingClockWise = true
            gameStarted = true
            
        }
        
        else if gameStarted == true {
           
            if movingClockWise == true {
                
                moveCounterClockWise()
                movingClockWise = false
                
            }
                
            else if movingClockWise == false{
                
                moveClockWise()
                movingClockWise = true
                
            }
            
            DotTouched()
            
        }
        
    }
   
    func DotTouched(){
        if intersected == true{
            
            Dot.removeFromParent()
            AddDot()
            intersected = false
            
        }
        else if intersected == false{
            died()
        }
        
    }
    
    func died(){
        LevelLabel.removeFromSuperview()
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 1.0, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1, action2]))
        movingClockWise = false
        intersected = false
        gameStarted = false
        self.loadView()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if Person.intersectsNode(Dot){
            intersected = true
            level++
            LevelLabel.text = "\(level)"
        }
        else{
            if intersected == true{
                if Person.intersectsNode(Dot) == false{
                    
                    died()
                }
                
            }
        }
        
    }
}
