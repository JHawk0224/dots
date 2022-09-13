//
//  Menu.swift
//  Dots
//
//  Created by iD Student on 7/24/17.
//  Copyright © 2017 iD Student. All rights reserved.
//
import UIKit
class Menu: UIViewController {
    var circle : [CALayer]!
    let defaults = UserDefaults.standard
    @IBOutlet var highscore : UILabel!
    @IBOutlet var previousScore : UILabel!
    var timer : Timer!
    let label = CATextLayer()
    var timer2 : Timer!
    var test : Int = 1
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.circle = Array<CALayer>()
        if defaults.string(forKey: "highscore") == nil {
            defaults.set("0", forKey: "highscore")
            defaults.set("locked", forKey: "Menu Tap")
            defaults.set("locked", forKey: "Score 10 Points")
            defaults.set("locked", forKey: "Score 20 Points")
            defaults.set("BlueCircle", forKey: "player")
            defaults.set("RedCircle", forKey: "enemy")
            defaults.set("GreyCircle", forKey: "hardEnemy")
        }
        Game.player = defaults.string(forKey: "player")!
        Game.enemy = defaults.string(forKey: "enemy")!
        Game.hardEnemy = defaults.string(forKey: "hardEnemy")!
        highscore.text = "Highscore: " + defaults.string(forKey: "highscore")!
        previousScore.text = "Previous Score: " + String(Game.scoreValue)
        circle.append(CALayer())
        initializeCircle(which: 0)
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    @IBAction func segue(sender : UIButton) {
        if sender.currentTitle == "Start New Game" {
            timer.invalidate()
            performSegue(withIdentifier: "StartNewGame", sender: nil)
        }
        if sender.currentTitle == "Dotz" {
            unlockAchievement(AchievementName: "Menu Tap")
        }
    }
    func initializeCircle(which : Int) {
        circle[which].bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        circle[which].cornerRadius = 25.0
        circle[which].contents = UIImage(named: Game.enemy)?.cgImage
        let animation = CABasicAnimation(keyPath: "position")
        var endingPoint = NSValue(cgPoint: CGPoint(x: 0, y: 0))
        let x = arc4random_uniform(3) + 1
        if x == 1 {
            animation.duration = Double(self.view.frame.size.height / 30)
            circle[which].position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))), y: 0)
            endingPoint = NSValue(cgPoint: CGPoint(x: circle[which].position.x, y: self.view.frame.size.height))
        } else if x == 2 {
            animation.duration = Double(self.view.frame.size.height / 30)
            circle[which].position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))), y: self.view.frame.size.height)
            endingPoint = NSValue(cgPoint: CGPoint(x: circle[which].position.x, y: 0))
        } else if x == 3 {
            animation.duration = Double(self.view.frame.size.width / 30)
            circle[which].position = CGPoint(x: 0, y: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))))
            endingPoint = NSValue(cgPoint: CGPoint(x: self.view.frame.size.width, y: circle[which].position.y))
        } else if x == 4 {
            animation.duration = Double(self.view.frame.size.width / 30)
            circle[which].position = CGPoint(x: self.view.frame.size.width, y: CGFloat(arc4random_uniform(UInt32(self.view.frame.size.width))))
            endingPoint = NSValue(cgPoint: CGPoint(x: 0, y: circle[which].position.y))
        }
        let startingPoint = NSValue(cgPoint: circle[which].position)
        view.layer.insertSublayer(circle[which], at: 0)
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.fromValue = startingPoint
        animation.toValue = endingPoint
        animation.autoreverses = true
        circle[which].add(animation, forKey: "linearMovement")
    }
    func unlockAchievement(AchievementName : String) {
        if defaults.string(forKey: AchievementName) != "unlocked" {
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
    @objc func runTimedCode() {
        circle.append(CALayer())
        initializeCircle(which: test)
        test += 1
        if test == 12 {
            timer.invalidate()
        }
    }
}
