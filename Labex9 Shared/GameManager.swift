import Foundation
import SpriteKit

class GameManager
{
    private var points:Int = 0
    var pointsLabel:SKLabelNode!
    var gameOverCallBack:((String)->Void)
    
    private init() {
        self.gameOverCallBack = { _ in }
    }
       
    func getPoints() -> Int {
           return points
       }
    
    func addPoints(value:Int) {
        points += value
        pointsLabel.text = "\(points)"
        if points>=5
        {
            gameOver(won: true)
        }
    }
    
    func gameOver(won:Bool) {
        gameOverCallBack(won ? "You Won!" : "Game Over!")
    }
    
    private static var instance:GameManager! =
    {
        let gm = GameManager()
        return gm
    }()
    
    class func shared()->GameManager {
        return instance
    }
}
