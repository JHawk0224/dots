//
//  Achievements.swift
//  Dots
//
//  Created by iD Student on 7/26/17.
//  Copyright © 2017 iD Student. All rights reserved.
//
import UIKit
class Achievements: UIViewController {
    @IBOutlet var picture11 : UIButton!
    @IBOutlet var picture12 : UIButton!
    @IBOutlet var label1 : UIButton!
    @IBOutlet var picture21 : UIButton!
    @IBOutlet var picture22 : UIButton!
    @IBOutlet var label2 : UIButton!
    @IBOutlet var picture31 : UIButton!
    @IBOutlet var picture32 : UIButton!
    @IBOutlet var label3 : UIButton!
    let defaults = UserDefaults.standard
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.contentHorizontalAlignment = .left
        label2.contentHorizontalAlignment = .left
        label3.contentHorizontalAlignment = .left
        if defaults.string(forKey: "Menu Tap") == "unlocked" {
            picture12.setBackgroundImage(UIImage(named: "PlayerUpgrade.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            picture12.setBackgroundImage(UIImage(named: "PlayerUpgrade.png")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            if Game.player == "BlueCircle" {
                label1.setTitle("Blue Player Equipped!", for: .normal)
            } else if Game.player == "PlayerUpgrade" {
                label1.setTitle("Special Player Equipped!", for: .normal)
            }
        } else if defaults.string(forKey: "Menu Tap") == "locked" {
            picture12.setBackgroundImage(UIImage(named: "lock.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            picture12.setBackgroundImage(UIImage(named: "lock.png")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            label1.setTitle("How do I unlock this?", for: .normal)
        }
        if defaults.string(forKey: "Score 10 Points") == "unlocked" {
            picture22.setBackgroundImage(UIImage(named: "SpecialEnemy.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            picture22.setBackgroundImage(UIImage(named: "SpecialEnemy.png")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            if Game.enemy == "RedCircle" {
                label2.setTitle("Red Enemy Equipped!", for: .normal)
            } else if Game.enemy == "SpecialEnemy" {
                label2.setTitle("Special Enemy Equipped!", for: .normal)
            }
        } else if defaults.string(forKey: "Score 10 Points") == "locked" {
            picture22.setBackgroundImage(UIImage(named: "lock.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            picture22.setBackgroundImage(UIImage(named: "lock.png")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            label2.setTitle("Score 10 Points", for: .normal)
        }
        if defaults.string(forKey: "Score 20 Points") == "unlocked" {
            picture32.setBackgroundImage(UIImage(named: "SpecialHardEnemy.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            picture32.setBackgroundImage(UIImage(named: "SpecialHardEnemy.png")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            if Game.hardEnemy == "GreyCircle" {
                label3.setTitle("Grey Trackers Equipped!", for: .normal)
            } else if Game.hardEnemy == "SpecialHardEnemy" {
                label3.setTitle("Special Trackers Equipped!", for: .normal)
            }
        } else if defaults.string(forKey: "Score 20 Points") == "locked" {
            picture32.setBackgroundImage(UIImage(named: "lock.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            picture32.setBackgroundImage(UIImage(named: "lock.png")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
            label3.setTitle("Score 20 Points", for: .normal)
        }
    }
    @IBAction func equipped(sender : UIButton) {
        if defaults.string(forKey: "Menu Tap") == "unlocked" {
            if sender.tag == 1 {
                Game.player = "BlueCircle"
                defaults.set("BlueCircle", forKey: "player")
                label1.setTitle("Blue Player Equipped!", for: .normal)
            } else if sender.tag == 2 {
                Game.player = "PlayerUpgrade"
                defaults.set("PlayerUpgrade", forKey: "player")
                label1.setTitle("Special Player Equipped!", for: .normal)
            }
        }
        if defaults.string(forKey: "Score 10 Points") == "unlocked" {
            if sender.tag == 3 {
                Game.enemy = "RedCircle"
                defaults.set("RedCircle", forKey: "enemy")
                label2.setTitle("Red Enemy Equipped!", for: .normal)
            } else if sender.tag == 4 {
                Game.enemy = "SpecialEnemy"
                defaults.set("SpecialEnemy", forKey: "enemy")
                label2.setTitle("Special Enemy Equipped!", for: .normal)
            }
        }
        if defaults.string(forKey: "Score 20 Points") == "unlocked" {
            if sender.tag == 5 {
                Game.hardEnemy = "GreyCircle"
                defaults.set("GreyCircle", forKey: "hardEnemy")
                label3.setTitle("Grey Trackers Equipped!", for: .normal)
            } else if sender.tag == 6 {
                Game.hardEnemy = "SpecialHardEnemy"
                defaults.set("SpecialHardEnemy", forKey: "hardEnemy")
                label3.setTitle("Special Trackers Equipped!", for: .normal)
            }
        }
        if sender.currentTitle == "Restore Defaults" {
            Game.player = "BlueCircle"
            defaults.set("BlueCircle", forKey: "player")
            equipped(sender: picture11)
            Game.enemy = "RedCircle"
            defaults.set("RedCircle", forKey: "enemy")
            equipped(sender: picture21)
            Game.hardEnemy = "GreyCircle"
            defaults.set("GreyCircle", forKey: "hardEnemy")
            equipped(sender: picture31)
        }
    }
}
