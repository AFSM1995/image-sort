//
//  SettingsScreenViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SettingsSceenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Views
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var tableVIew: UITableView!
    
    // Text Buttons
    @IBOutlet weak var clearBarrierButton: UIButton!
    @IBOutlet weak var clearPathButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var snakeSpeedButton: UIButton!
    @IBOutlet weak var squareSizeButton: UIButton!
    @IBOutlet weak var displayFormatButton: UIButton!
    
    // Icon Buttons
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var stepOrPlayPauseButton: UIButton!
    @IBOutlet weak var darkOrLightModeButton: UIButton!
    
    weak var gameScreenViewController: GameScreenViewController!
    
    let defaults = UserDefaults.standard
    var legendData = UserDefaults.standard.array(forKey: "Legend Preferences") as! [[Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        loadButtonStyling()
    }
    
    func loadUserData() {
        defaults.bool(forKey: "Dark Mode On Setting") == true ? (overrideUserInterfaceStyle = .dark) : (overrideUserInterfaceStyle = .light)
    }
    
    func loadButtonStyling() {
        var options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonLoader(targetButton: snakeSpeedButton, key: "Snake Speed Text Setting", optionArray: options)
        options = ["Size: Extra Small", "Size: Small", "Size: Medium", "Size: Large"]
        fourOptionButtonLoader(targetButton: squareSizeButton, key: "Square Size Setting", optionArray: options)
        
        resetButton.setTitle("No Changes", for: .normal)
        defaults.set(1, forKey: "Reset Setting")
        
        boolButtonLoader(isIconButton: false, targetButton: displayFormatButton, key: "Display Grid Setting", trueOption: "Format: Grid", falseOption: "Format: Row")
        boolButtonLoader(isIconButton: true, targetButton: soundButton, key: "Volume On Setting", trueOption: "Volume_On_Icon_Set", falseOption: "Volume_Mute_Icon_Set")
        boolButtonLoader(isIconButton: true, targetButton: stepOrPlayPauseButton, key: "Step Mode On Setting", trueOption: "Step_Icon_Set", falseOption: "Play_Icon_Set")
        boolButtonLoader(isIconButton: true, targetButton: darkOrLightModeButton, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon_Set", falseOption: "Light_Mode_Icon_Set")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsScreenTableViewCell
        let cellText = (legendData[indexPath.row][0] as? String)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.legendOptionText.text = legendData[indexPath.row][0] as? String
        cell.legendOptionSquareColor.backgroundColor = colorPaletteManager(cellText: cellText)[(legendData[indexPath.row][1] as? Int)!]
        cell.legendOptionSquareColor.layer.borderWidth = 1
        cell.legendOptionSquareColor.layer.cornerRadius = cell.legendOptionSquareColor.frame.size.width/4
        cell.legendOptionSquareColor.tag = indexPath.row
        cell.legendOptionSquareColor.isUserInteractionEnabled = true
        cell.legendOptionSquareColor.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedSquare = tapGestureRecognizer.view as! UIImageView
        let cellText = legendData[tappedSquare.tag][0] as! String
        let colorPalette = colorPaletteManager(cellText: cellText)
        var colorID = (legendData[tappedSquare.tag][1] as! Int) + 1
        
        colorID == colorPalette.count ? (colorID = 0) : ()
        defaults.setColor(color: colorPalette[(legendData[tappedSquare.tag][1] as! Int)], forKey: legendData[tappedSquare.tag][0] as! String)
        legendData[tappedSquare.tag][1] = colorID
        defaults.set(legendData, forKey: "Legend Preferences")
        tableVIew.reloadData()
        changeNotifier()
    }
    
    @IBAction func clearAllButtonTapped(_ sender: UIButton) {
        sender.setTitle("Gameboard Cleared", for: .normal)
        clearBarrierButton.setTitle("Barriers Cleared", for: .normal)
        clearPathButton.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear All Setting")
        defaults.set(true, forKey: "Settings Value Modified")
    }
    
    @IBAction func clearBarrierButtonTapped(_ sender: UIButton) {
        sender.setTitle("Barriers Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Barrier Setting")
        defaults.set(true, forKey: "Settings Value Modified")
    }
    
    @IBAction func clearPathButtonTapped(_ sender: UIButton) {
        sender.setTitle("Path Cleared", for: .normal)
        defaults.set(true, forKey: "Clear Path Setting")
        defaults.set(true, forKey: "Settings Value Modified")
    }
    
    @IBAction func snakeSpeedButtonTapped(_ sender: UIButton) {
        let options = ["Speed: Slow", "Speed: Normal", "Speed: Fast", "Speed: Extreme"]
        fourOptionButtonResponder(sender, isSpeedButton: true, key: "Snake Speed Text Setting", optionArray: options)
    }
    
    @IBAction func squareSizeButtonTapped(_ sender: UIButton) {
        let options = ["Size: Extra Small", "Size: Small", "Size: Medium", "Size: Large"]
        fourOptionButtonResponder(sender, isSpeedButton: false, key: "Square Size Setting", optionArray: options)
    }
    
    @IBAction func displayFormatButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: false, key: "Display Grid Setting", trueOption: "Format: Grid", falseOption: "Format: Row")
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let options = ["No Changes", "Reset: Board", "Reset: Most", "Reser: Few", "Reset: Few Unique", "Reset: Left", "Reset: Center", "Reset: Right", "Reset: Reverse Sorted", "Reset: Sorted"]
        tenOptionButtonResponder(sender, isSpeedButton: false, key: "Reset Setting", optionArray: options)
    }
    
    @IBAction func returnButtonTapped(_ sender: UIButton) {
        defaults.set(true, forKey: "Settings Dismissed")
        self.dismiss(animated: true)
    }
    
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Volume On Setting", trueOption: "Volume_On_Icon_Set", falseOption: "Volume_Mute_Icon_Set")
    }
    
    @IBAction func stepButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Step Mode On Setting", trueOption: "Step_Icon_Set", falseOption: "Play_Icon_Set")
    }
    
    @IBAction func darkModeButtonTapped(_ sender: UIButton) {
        boolButtonResponder(sender, isIconButton: true, key: "Dark Mode On Setting", trueOption: "Dark_Mode_Icon_Set", falseOption: "Light_Mode_Icon_Set")
        
        if (defaults.bool(forKey: "Dark Mode On Setting")) == true {
            UIWindow.animate(withDuration: 1.3, animations: {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
                self.overrideUserInterfaceStyle = .dark
                self.presentingViewController?.overrideUserInterfaceStyle = .dark
            })
        } else {
            UIWindow.animate(withDuration: 1.3, animations: {
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
                self.overrideUserInterfaceStyle = .light
                self.presentingViewController?.overrideUserInterfaceStyle = .light
            })
        }
        tableVIew.reloadData()
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.gameScreenViewController = (vc.presentedViewController as? GameScreenViewController)

            self.dismiss(animated: true) {
                if self.gameScreenViewController != nil {
                    self.gameScreenViewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
