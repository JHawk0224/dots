//
//  Game.swift
//  Dots
//
//  Created by iD Student on 7/24/17.
//  Copyright © 2017 iD Student. All rights reserved.
//
import UIKit
class Game: UIViewController {
    let circleLayer = CALayer()
    let progressBar = CALayer()
    var enemyArray : [CALayer]!
    var hardEnemyArray : [CALayer]! = []
    var enemyDirections : [String]! = []
    @IBOutlet var square : UILabel!
    @IBOutlet var score : UILabel!
    @IBOutlet var highscore : UILabel!
    @IBOutlet var death : UILabel!
    @IBOutlet var pauseLayer : UILabel!
    @IBOutlet var progressBlack : UILabel!
    @IBOutlet var progressWhite : UILabel!
    @IBOutlet var freezeLayer : UIButton!
    @IBOutlet var warning : UILabel!
    @IBOutlet var pause : UIButton!
    @IBOutlet var menuButton : UIButton!
    @IBOutlet var continueButton : UIButton!
    @IBOutlet var freeze : UIButton!
    @IBOutlet var newGame : UIButton!
    @IBOutlet var pacman : UIButton!
    var speed : Double = 150
    static var scoreValue : Int = 0
    var greenEarned : Int = 0
    var dotsEaten : Int = 0
    var direction : [String] = []
    let label = CATextLayer()
    let defaults = UserDefaults.standard
    var timer : Timer!
    var freezeIsGoing = false
    var enemiesToGen : Int = 0
    var hardEnemiesToGen : Int = 0
    static var player = "BlueCircle"
    static var enemy = "RedCircle"
    static var hardEnemy = "GreyCircle"
    var test = true
    var whichOne : Int = 0
    var saveFreeze : Double = 0.0
    var timer3 : Timer!
    var deletePowerup : Timer!
    var pacmanBar : Timer!
    var timer2 : Timer!
    var pauseBool = false
    var startTime3 = NSDate.timeIntervalSinceReferenceDate
    var elapsedTime3 = 0.0
    var deletePowerupStart = NSDate.timeIntervalSinceReferenceDate
    var deletePowerupElapsed = 0.0
    var pacmanBarStart = NSDate.timeIntervalSinceReferenceDate
    var pacmanBarElapsed = 0.0
    var deletePowerupIsGoing = false
    var pacmanOn = false
    var thread = DispatchQueue.global(qos: .background)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        Game.scoreValue = 0
        self.highscore.text = "Highscore: " + defaults.string(forKey: "highscore")!
        Game.player = defaults.string(forKey: "player")!
        Game.enemy = defaults.string(forKey: "enemy")!
        Game.hardEnemy = defaults.string(forKey: "hardEnemy")!
        self.initializeCircleLayer()
        self.square.frame.origin.x = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width - 50)) + 20)
        self.square.frame.origin.y = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.height - 50)) + 20)
        self.enemyArray = Array<CALayer>()
        continueButton.isEnabled = false
        menuButton.isEnabled = false
        freezeLayer.isEnabled = false
        freeze.isEnabled = false
        newGame.isEnabled = false
        pause.isEnabled = true
        pacman.isEnabled = false
        initializeProgressBar()
        progressBar.isHidden = true
        thread.async {
            while self.test == true {
                DispatchQueue.main.async{
                    self.updateHardEnemies()
                    self.testPowerupCollision(circleCenterX: self.circleLayer.position.x, circleCenterY: self.circleLayer.position.y, powerup: "freeze")
                    self.testPowerupCollision(circleCenterX: self.circleLayer.position.x, circleCenterY: self.circleLayer.position.y, powerup: "pacman")
                    if let presPos = self.circleLayer.presentation() {
                        self.testCollision(circleCenterX: presPos.position.x, circleCenterY: presPos.position.y, squareCenterX: self.square.frame.origin.x + (self.square.frame.size.width / 2), squareCenterY: self.square.frame.origin.y + (self.square.frame.size.height / 2))
                    } else {
                        self.testCollision(circleCenterX: self.circleLayer.position.x, circleCenterY: self.circleLayer.position.y, squareCenterX: self.square.frame.origin.x + (self.square.frame.size.width / 2), squareCenterY: self.square.frame.origin.y + (self.square.frame.size.height / 2))
                    }
                    self.testEnemyCollision(circleCenterX: self.circleLayer.position.x, circleCenterY: self.circleLayer.position.y)
                    self.testHardEnemyCollision(circleCenterX: self.circleLayer.position.x, circleCenterY: self.circleLayer.position.y)
                }
                usleep(10000)
            }
        }
    }
    func initializeCircleLayer() {
        circleLayer.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        circleLayer.position = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        circleLayer.cornerRadius = 25.0
        circleLayer.contents = UIImage(named: Game.player)?.cgImage
        self.view.layer.insertSublayer(circleLayer, below: score.layer)
    }
    func initializeProgressBar() {
        progressBar.bounds = CGRect(x: 0, y: 0, width: 311, height: 17)
        progressBar.position = CGPoint(x: self.view.frame.size.width / 2, y: 19.5)
        progressBar.backgroundColor = UIColor.green.cgColor
        self.view.layer.addSublayer(progressBar)
    }
    func genPowerup() {
        let x = arc4random_uniform(10)
        if x == 1 {
            let y = arc4random_uniform(2)
            if y == 0 {
                self.freeze.frame.origin.x = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width - 40)) + 20)
                self.freeze.frame.origin.y = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.height - 40)) + 20)
            } else if y == 1 {
                self.pacman.frame.origin.x = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width - 40)) + 20)
                self.pacman.frame.origin.y = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.height - 40)) + 20)
            }
            deletePowerupStart = NSDate.timeIntervalSinceReferenceDate
            deletePowerupIsGoing = true
            deletePowerup = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(movePowerup), userInfo: nil, repeats: false)
        }
    }
    @objc func movePowerup() {
        self.freeze.frame.origin.x = -1000
        self.freeze.frame.origin.y = -1000
        self.pacman.frame.origin.x = -1000
        self.pacman.frame.origin.y = -1000
        deletePowerup.invalidate()
        deletePowerupIsGoing = false
    }
    func testPowerupCollision(circleCenterX : CGFloat, circleCenterY : CGFloat, powerup : String) {
        var powerupCenterX : CGFloat = 0
        var powerupCenterY : CGFloat = 0
        if powerup == "freeze" {
            powerupCenterX = freeze.frame.origin.x + (freeze.frame.size.width / 2)
            powerupCenterY = freeze.frame.origin.y + (freeze.frame.size.height / 2)
        } else if powerup == "pacman" {
            powerupCenterX = pacman.frame.origin.x + (pacman.frame.size.width / 2)
            powerupCenterY = pacman.frame.origin.y + (pacman.frame.size.height / 2)
        }
        let diffInX : Double = Double(circleCenterX - powerupCenterX)
        let diffInY : Double = Double(circleCenterY - powerupCenterY)
        let distance : Double = sqrt(pow(diffInX, 2) + pow(diffInY, 2))
        if distance <= 30 {
            if powerup == "freeze" {
                self.freeze.frame.origin.x = -1000
                self.freeze.frame.origin.y = -1000
                if let x = self.view.layer.sublayers {
                    for layer in x {
                        if layer != circleLayer {
                            let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
                            layer.speed = 0.0
                            layer.timeOffset = pausedTime
                        }
                    }
                }
                freezeIsGoing = true
                freezeLayer.alpha = 0.95
                startTime3 = NSDate.timeIntervalSinceReferenceDate
                timer3 = Timer.scheduledTimer(timeInterval: 0.05263157894, target: self, selector: #selector(decreaseFreeze), userInfo: nil, repeats: true)
            } else if powerup == "pacman" {
                self.pacman.frame.origin.x = -1000
                self.pacman.frame.origin.y = -1000
                pacmanOn = true
                self.view.backgroundColor = UIColor.yellow
                progressBar.isHidden = false
                progressBlack.alpha = 1.0
                progressWhite.alpha = 1.0
                pacmanBarStart = NSDate.timeIntervalSinceReferenceDate
                pacmanBar = Timer.scheduledTimer(timeInterval: 0.009646302250804, target: self, selector: #selector(pacmanCountdown), userInfo: nil, repeats: true)
            }
        }
    }
    @objc func pacmanCountdown() {
        progressBar.frame.size.width -= 1
        if progressBar.frame.size.width <= 0 {
            pacmanBar.invalidate()
            progressBar.isHidden = true
            progressBlack.alpha = 0.0
            progressWhite.alpha = 0.0
            progressBar.frame.size.width = 311
            pacmanOn = false
            self.view.backgroundColor = UIColor.white
        }
    }
    @objc func decreaseFreeze() {
        freezeLayer.alpha -= 0.01
        if freezeLayer.alpha <= 0.0 {
            timer3.invalidate()
            freezeIsGoing = false
            for _ in 0 ..< enemiesToGen {
                enemyArray.append(CALayer())
                initializeEnemies()
            }
            for _ in 0 ..< hardEnemiesToGen {
                hardEnemyArray.append(CALayer())
                initializeHardEnemies()
            }
            enemiesToGen = 0
            hardEnemiesToGen = 0
            freezeLayer.alpha = 0.0
            if let x = self.view.layer.sublayers {
                for layer in x {
                    if layer != circleLayer {
                        let pausedTime: CFTimeInterval = layer.timeOffset
                        layer.speed = 1.0
                        layer.timeOffset = 0.0
                        layer.beginTime = 0.0
                        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                        layer.beginTime = timeSincePause
                    }
                }
            }
        }
    }
    @objc func timer3Begin() {
        timer3.invalidate()
        startTime3 = NSDate.timeIntervalSinceReferenceDate
        timer3 = Timer.scheduledTimer(timeInterval: (0.05263157894), target: self, selector: #selector(decreaseFreeze), userInfo: nil, repeats: true)
    }
    @objc func pacmanBegin() {
        pacmanBar.invalidate()
        pacmanBarStart = NSDate.timeIntervalSinceReferenceDate
        pacmanBar = Timer.scheduledTimer(timeInterval: (0.009646302250804), target: self, selector: #selector(pacmanCountdown), userInfo: nil, repeats: true)
    }
    @IBAction func pause(sender : UIButton) {
        if sender.tag == 100 && newGame.isEnabled == false {
            pauseBool = true
            if freezeIsGoing == false {
                if let x = self.view.layer.sublayers {
                    for layer in x {
                        if layer != label {
                            let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
                            layer.speed = 0.0
                            layer.timeOffset = pausedTime
                        }
                    }
                }
            }
            saveFreeze = Double(freezeLayer.alpha)
            freezeLayer.alpha = 0.0
            if freezeIsGoing == true {
                elapsedTime3 = NSDate.timeIntervalSinceReferenceDate - startTime3
                timer3.invalidate()
            }
            if deletePowerupIsGoing == true {
                deletePowerupElapsed = NSDate.timeIntervalSinceReferenceDate - deletePowerupStart
                deletePowerup.invalidate()
            }
            if pacmanOn == true {
                pacmanBarElapsed = NSDate.timeIntervalSinceReferenceDate - pacmanBarStart
                pacmanBar.invalidate()
            }
            continueButton.isEnabled = true
            menuButton.isEnabled = true
            pause.isEnabled = false
            pauseLayer.alpha = 0.25
            continueButton.alpha = 0.95
            menuButton.alpha = 0.95
            warning.alpha = 0.95
        }
        if sender.currentTitle == "Resume Game" {
            if freezeIsGoing == false {
                if let x = self.view.layer.sublayers {
                    for layer in x {
                        if layer != label {
                            let pausedTime: CFTimeInterval = layer.timeOffset
                            layer.speed = 1.0
                            layer.timeOffset = 0.0
                            layer.beginTime = 0.0
                            let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                            layer.beginTime = timeSincePause
                        }
                    }
                }
            }
            freezeLayer.alpha = CGFloat(saveFreeze)
            saveFreeze = 0.0
            if freezeIsGoing == true {
                startTime3 = NSDate.timeIntervalSinceReferenceDate
                timer3 = Timer.scheduledTimer(timeInterval: (0.05263157894 - elapsedTime3), target: self, selector: #selector(timer3Begin), userInfo: nil, repeats: false)
            }
            if deletePowerupIsGoing == true {
                deletePowerupStart = NSDate.timeIntervalSinceReferenceDate
                deletePowerup = Timer.scheduledTimer(timeInterval: (5 - deletePowerupElapsed), target: self, selector: #selector(movePowerup), userInfo: nil, repeats: false)
            }
            if pacmanOn == true {
                pacmanBarStart = NSDate.timeIntervalSinceReferenceDate
                pacmanBar = Timer.scheduledTimer(timeInterval: (0.009646302250804 - pacmanBarElapsed), target: self, selector: #selector(pacmanBegin), userInfo: nil, repeats: false)
            }
            pauseBool = false
            continueButton.isEnabled = false
            menuButton.isEnabled = false
            pause.isEnabled = true
            pauseLayer.alpha = 0.0
            continueButton.alpha = 0.0
            menuButton.alpha = 0.0
            warning.alpha = 0.0
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pauseBool == false {
            if let touch = touches.first {
                let position = touch.location(in: view)
                move(place: position)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pauseBool == false {
            if let touch = touches.first {
                let position = touch.location(in: view)
                move(place: position)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pauseBool == false {
            circleLayer.position.x = (circleLayer.presentation()?.position.x)!
            circleLayer.position.y = (circleLayer.presentation()?.position.y)!
            circleLayer.removeAllAnimations()
        }
    }
    func move(place: CGPoint) {
        let cords = CGPoint(x: (circleLayer.presentation()?.position.x)!, y: (circleLayer.presentation()?.position.y)!)
        circleLayer.position.x = (circleLayer.presentation()?.position.x)!
        circleLayer.position.y = (circleLayer.presentation()?.position.y)!
        circleLayer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "position")
        animation.repeatCount = 0
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        let startingPoint = NSValue(cgPoint: cords)
        let endingPoint = NSValue(cgPoint: place)
        animation.fromValue = startingPoint
        animation.toValue = endingPoint
        animation.duration = sqrt(Double(pow(cords.x - place.x, 2) + pow(cords.y - place.y, 2))) / speed
        circleLayer.add(animation, forKey: "linearMovement")
    }
    func testCollision(circleCenterX : CGFloat, circleCenterY : CGFloat, squareCenterX : CGFloat, squareCenterY : CGFloat) {
        let diffInX : Double = Double(circleCenterX - squareCenterX)
        let diffInY : Double = Double(circleCenterY - squareCenterY)
        let distance : Double = sqrt(pow(diffInX, 2) + pow(diffInY, 2))
        if distance <= 25 {
            if speed < 450 {
                speed += 10
            } else {
                speed = 450
            }
            square.frame.origin.x = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width - 50)) + 20)
            square.frame.origin.y = CGFloat(arc4random_uniform(UInt32(self.view.frame.size.height - 50)) + 20)
            if pacmanOn == false && freezeIsGoing == false && pacman.frame.origin.x == -1000 && freeze.frame.origin.x == -1000 {
                genPowerup()
            }
            greenEarned += 1
            Game.scoreValue = greenEarned + dotsEaten
            score.text = "Score: " + String(Game.scoreValue)
            if freezeIsGoing == false {
                enemyArray.append(CALayer())
                initializeEnemies()
                if greenEarned % 5 == 0 {
                    hardEnemyArray.append(CALayer())
                    initializeHardEnemies()
                }
            } else {
                enemiesToGen += 1
                if greenEarned % 5 == 0 {
                    hardEnemiesToGen += 1
                }
            }
            if Game.scoreValue == 10 && defaults.string(forKey: "Score 10 Points")! == "locked" {
                unlockAchievement(AchievementName: "Score 10 Points")
            }
            if Game.scoreValue == 20 && defaults.string(forKey: "Score 20 Points")! == "locked" {
                unlockAchievement(AchievementName: "Score 20 Points")
            }
        }
    }
    func testEnemyCollision(circleCenterX : CGFloat, circleCenterY : CGFloat) {
        var toRemove : [Int] = []
        for x in 0 ..< enemyArray.count {
            if let pres = enemyArray[x].presentation() {
                let diffInX : Double = Double(circleCenterX - pres.position.x)
                let diffInY : Double = Double(circleCenterY - pres.position.y)
                let distance : Double = sqrt(pow(diffInX, 2) + pow(diffInY, 2))
                if distance <= 30 {
                    if pacmanOn == false {
                        lose()
                    } else {
                        dotsEaten += 1
                        Game.scoreValue = dotsEaten + greenEarned
                        score.text = "Score: " + String(Game.scoreValue)
                        enemyArray[x].removeAllAnimations()
                        enemyArray[x].removeFromSuperlayer()
                        toRemove.append(x)
                    }
                }
            }
        }
        toRemove.sort { $0 > $1 }
        for x in 0 ..< toRemove.count {
            enemyArray.remove(at: toRemove[x])
        }
    }
    func testHardEnemyCollision(circleCenterX : CGFloat, circleCenterY : CGFloat) {
        var toRemove : [Int] = []
        for x in 0 ..< hardEnemyArray.count {
            if let pres = hardEnemyArray[x].presentation() {
                let diffInX : Double = Double(circleCenterX - pres.position.x)
                let diffInY : Double = Double(circleCenterY - pres.position.y)
                let distance : Double = sqrt(pow(diffInX, 2) + pow(diffInY, 2))
                if distance <= 32.5 {
                    if pacmanOn == false {
                        lose()
                    } else {
                        hardEnemyArray[x].removeAllAnimations()
                        hardEnemyArray[x].removeFromSuperlayer()
                        toRemove.append(x)
                    }
                }
            }
        }
        toRemove.sort { $0 > $1 }
        for x in 0 ..< toRemove.count {
            hardEnemyArray.remove(at: toRemove[x])
        }
    }
    func updateHardEnemies() {
        for x in 0 ..< hardEnemyArray.count {
            if let pres = hardEnemyArray[x].presentation() {
                hardEnemyArray[x].position.x = pres.position.x
                hardEnemyArray[x].position.y = pres.position.y
                hardEnemyArray[x].removeAllAnimations()
                let animation = CABasicAnimation(keyPath: "position")
                animation.repeatCount = Float.infinity
                animation.fillMode = kCAFillModeForwards
                animation.isRemovedOnCompletion = false
                let startingPoint = NSValue(cgPoint: pres.position)
                let endingPoint = NSValue(cgPoint: (circleLayer.presentation()?.position)!)
                animation.duration = sqrt(Double(pow(pres.position.x - (circleLayer.presentation()?.position.x)!, 2) + pow(pres.position.y - (circleLayer.presentation()?.position.y)!, 2))) / (speed / 2)
                animation.fromValue = startingPoint
                animation.toValue = endingPoint
                hardEnemyArray[x].add(animation, forKey: "tracer")
            }
        }
    }
    func initializeEnemies() {
        enemyArray[enemyArray.count - 1].bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        enemyArray[enemyArray.count - 1].cornerRadius = 25.0
        enemyArray[enemyArray.count - 1].contents = UIImage(named: Game.enemy)?.cgImage
        let animation = CABasicAnimation(keyPath: "position")
        var endingPoint = NSValue(cgPoint: CGPoint(x: 0, y: 0))
        let x = arc4random_uniform(3) + 1
        if x == 1 {
            animation.duration = Double(self.view.frame.size.height / 30)
            enemyArray[enemyArray.count - 1].position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))), y: 0)
            endingPoint = NSValue(cgPoint: CGPoint(x: enemyArray[enemyArray.count - 1].position.x, y: self.view.frame.size.height))
            direction.append("down")
        } else if x == 2 {
            animation.duration = Double(self.view.frame.size.height / 30)
            enemyArray[enemyArray.count - 1].position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))), y: self.view.frame.size.height)
            endingPoint = NSValue(cgPoint: CGPoint(x: enemyArray[enemyArray.count - 1].position.x, y: 0))
            direction.append("up")
        } else if x == 3 {
            animation.duration = Double(self.view.frame.size.width / 30)
            enemyArray[enemyArray.count - 1].position = CGPoint(x: 0, y: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.height))))
            endingPoint = NSValue(cgPoint: CGPoint(x: self.view.frame.size.width, y: enemyArray[enemyArray.count - 1].position.y))
            direction.append("right")
        } else if x == 4 {
            animation.duration = Double(self.view.frame.size.width / 30)
            enemyArray[enemyArray.count - 1].position = CGPoint(x: self.view.frame.size.width, y: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.height))))
            endingPoint = NSValue(cgPoint: CGPoint(x: 0, y: enemyArray[enemyArray.count - 1].position.y))
            direction.append("left")
        }
        let startingPoint = NSValue(cgPoint: enemyArray[enemyArray.count - 1].position)
        self.view.layer.insertSublayer(enemyArray[enemyArray.count - 1], below: score.layer)
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.fromValue = startingPoint
        animation.toValue = endingPoint
        animation.autoreverses = true
        enemyArray[enemyArray.count - 1].add(animation, forKey: "linearMovement")
    }
    func initializeHardEnemies() {
        hardEnemyArray[hardEnemyArray.count - 1].bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
        hardEnemyArray[hardEnemyArray.count - 1].cornerRadius = 25.0
        hardEnemyArray[hardEnemyArray.count - 1].contents = UIImage(named: Game.hardEnemy)?.cgImage
        let x = arc4random_uniform(3) + 1
        if x == 1 {
            hardEnemyArray[hardEnemyArray.count - 1].position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))), y: 0)
        } else if x == 2 {
            hardEnemyArray[hardEnemyArray.count - 1].position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))), y: self.view.frame.size.height)
        } else if x == 3 {
            hardEnemyArray[hardEnemyArray.count - 1].position = CGPoint(x: 0, y: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))))
        } else if x == 4 {
            hardEnemyArray[hardEnemyArray.count - 1].position = CGPoint(x: self.view.frame.size.width, y: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))))
        }
        self.view.layer.insertSublayer(hardEnemyArray[hardEnemyArray.count - 1], below: score.layer)
        let animation = CABasicAnimation(keyPath: "position")
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        let startingPoint = NSValue(cgPoint: hardEnemyArray[hardEnemyArray.count - 1].position)
        let endingPoint = NSValue(cgPoint: (circleLayer.presentation()?.position)!)
        animation.duration = sqrt(Double(pow(hardEnemyArray[hardEnemyArray.count - 1].position.x - (circleLayer.presentation()?.position.x)!, 2) + pow(hardEnemyArray[hardEnemyArray.count - 1].position.y - (circleLayer.presentation()?.position.y)!, 2))) / (speed / 2)
        animation.fromValue = startingPoint
        animation.toValue = endingPoint
        hardEnemyArray[hardEnemyArray.count - 1].add(animation, forKey: "tracer")
    }
    func saveData(key: String, value: String) {
        defaults.set(value, forKey: key)
    }
    func lose() {
        pauseBool = false
        continueButton.isEnabled = false
        newGame.isEnabled = true
        menuButton.isEnabled = true
        pause.isEnabled = false
        continueButton.alpha = 0.0
        warning.alpha = 0.0
        pauseLayer.alpha = 0.25
        newGame.alpha = 0.95
        menuButton.alpha = 0.95
        death.alpha = 0.95
        if Game.scoreValue > Int(defaults.string(forKey: "highscore")!)! {
            saveData(key: "highscore", value: String(Game.scoreValue))
        }
        if freezeIsGoing == true {
            timer3.invalidate()
        }
        if deletePowerupIsGoing == true {
            deletePowerup.invalidate()
        }
        freezeLayer.alpha = 0.0
        test = false
        if let x = self.view.layer.sublayers {
            for layer in x {
                if layer != label {
                    let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
                    layer.speed = 0.0
                    layer.timeOffset = pausedTime
                }
            }
        }
    }
    func unlockAchievement(AchievementName : String) {
        if defaults.string(forKey: AchievementName) == "locked" {
            defaults.set("unlocked", forKey: AchievementName)
            label.font = "Helvetica-Bold" as CFTypeRef
            label.fontSize = 24
            label.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200)
            label.position = CGPoint(x: self.view.frame.size.width / 2, y: -100)
            label.string = "\n\n\n\nAchievement Unlocked!\n\(AchievementName)"
            label.opacity = 0.5
            label.cornerRadius = 25
            label.contentsScale = UIScreen.main.scale
            label.alignmentMode = kCAAlignmentCenter
            label.foregroundColor = UIColor.white.cgColor
            label.backgroundColor = UIColor.black.cgColor
            self.view.layer.addSublayer(label)
            let animation = CABasicAnimation(keyPath: "position")
            let startingPoint = NSValue(cgPoint: label.position)
            let endingPoint = NSValue(cgPoint: CGPoint(x: self.view.frame.size.width / 2, y: 0))
            animation.duration = 1
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.fromValue = startingPoint
            animation.toValue = endingPoint
            label.add(animation, forKey: "linearMovement")
            timer2 = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(unlockAchievement2), userInfo: nil, repeats: false)
        }
    }
    @objc func unlockAchievement2() {
        if let pres = label.presentation() {
            label.position = pres.position
        }
        label.removeAllAnimations()
        timer2.invalidate()
        let animation = CABasicAnimation(keyPath: "position")
        let startingPoint = NSValue(cgPoint: label.position)
        let endingPoint = NSValue(cgPoint: CGPoint(x: self.view.frame.size.width / 2, y: -100))
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration = 1
        animation.fromValue = startingPoint
        animation.toValue = endingPoint
        label.add(animation, forKey: "linearMovement")
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setCords), userInfo: nil, repeats: false)
    }
    @objc func setCords() {
        if let pres = label.presentation() {
            label.position = pres.position
        }
        label.removeAllAnimations()
        timer2.invalidate()
    }
    @objc func appMovedToBackground() {
        circleLayer.position.x = (circleLayer.presentation()?.position.x)!
        circleLayer.position.y = (circleLayer.presentation()?.position.y)!
        circleLayer.removeAllAnimations()
        pause(sender: pause)
    }
}
