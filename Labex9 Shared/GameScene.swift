import SpriteKit

class GameScene: SKScene {
    
    let gm = GameManager.shared()

    override func didMove(to view: SKView) {
        let pointsLabel = childNode(withName: "points") as! SKLabelNode
        gm.pointsLabel = pointsLabel
        
        gm.gameOverCallBack =
        {
            (msg:String) in
            
            let label = SKLabelNode()
            label.position = CGPoint.zero
            label.text = msg
            label.fontName = "Chalkduster"
            self.addChild(label)
            
            self.removeAction(forKey: "spawn")
        }
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.5)
        
        let spawnBall = SKAction.sequence([SKAction.wait(forDuration: 1),
                                           SKAction.customAction(withDuration: 0, actionBlock: { _,_ in
            if GameManager.shared().getPoints() < 5 { // Check if the game is still ongoing
                let redBall = SKShapeNode(circleOfRadius: CGFloat(25))
                redBall.name = "red"
                redBall.fillColor = SKColor.red
                redBall.position = CGPoint(x: CGFloat.random(in: self.frame.minX + 400..<self.frame.maxX - 400), y: self.frame.maxY - 200)
                redBall.physicsBody = SKPhysicsBody(circleOfRadius: 50)
                self.addChild(redBall)

                redBall.run(SKAction.sequence([SKAction.wait(forDuration: 5),
                                               SKAction.removeFromParent()]))
            }

            if GameManager.shared().getPoints() < 5 { // Check if the game is still ongoing
                let greenBall = SKShapeNode(circleOfRadius: CGFloat(25))
                greenBall.name = "green"
                greenBall.fillColor = SKColor.green
                greenBall.position = CGPoint(x: CGFloat.random(in: self.frame.minX + 400..<self.frame.maxX - 400), y: self.frame.maxY - 200)
                greenBall.physicsBody = SKPhysicsBody(circleOfRadius: 50)
                self.addChild(greenBall)

                greenBall.run(SKAction.sequence([SKAction.wait(forDuration: 5),
                                                  SKAction.customAction(withDuration: 0, actionBlock: { _,_ in
                    if GameManager.shared().getPoints() < 5 { // Check if the game is still ongoing
                        self.gm.addPoints(value: -1)
                    }
                }), SKAction.removeFromParent()]))
            }
        })])
        
        self.run(SKAction.repeatForever(spawnBall), withKey: "spawn")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if the game is already won
        if GameManager.shared().getPoints() >= 5 {
            return
        }

        for t in touches {
            for node in self.nodes(at: t.location(in: self)) {
                if node.name == "red" {
                    gm.gameOver(won: false)
                    node.removeFromParent()
                }
                else if node.name == "green" {
                    gm.addPoints(value: 1)
                    node.removeFromParent()
                }
            }
        }
    }
}
