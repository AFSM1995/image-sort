//
//  SelectionSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/5/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SelectionSort {
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func initialGameBoardAperianceSaver() -> [UIColor] {
        var initialGameboardLayout: [UIColor] = []
        for i in scene.playableGameboard {
            initialGameboardLayout.append(i.square.fillColor)
        }
        return initialGameboardLayout
    }
    
    func initialGameBoardAperianceRestorer(resuming: Bool, initialGameboardLayout: [UIColor]) {
        // Prevents sorted array grid from appering before initial animations begin.
        // If animation has to restart, prevents sorted array grid from apperaing before animations begin.
        if resuming == false {
            for i in scene.playableGameboard {
                i.square.fillColor = scene.gameboardSquareColor
            }
        } else {
            for (index, i) in (scene.playableGameboard).enumerated() {
                i.square.fillColor = initialGameboardLayout[index]
            }
        }
    }

    func selectionSort(gameboard: [SkNodeAndLocation], resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var pendingAnimations = [[SkNodeLocationAndColor]]()
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        var currentMinimumValue = CGFloat()
        var currentMinimumIndex = 0
        
        for (iIndex, _) in scene.playableGameboard.enumerated() {
            var redI: CGFloat = 0
            var greenI: CGFloat = 0
            var blueI: CGFloat = 0
            var alphaI: CGFloat = 0
            var redJ: CGFloat = 0
            var greenJ: CGFloat = 0
            var blueJ: CGFloat = 0
            var alphaJ: CGFloat = 0
            var redMin: CGFloat = 0
            var greenMin: CGFloat = 0
            var blueMin: CGFloat = 0
            var alphaMin: CGFloat = 0
            
            scene.playableGameboard[iIndex].square.fillColor.getRed(&redI, green: &greenI, blue: &blueI, alpha: &alphaI)
            currentMinimumValue = alphaI
            currentMinimumIndex = iIndex
            redMin = redI
            greenMin = greenI
            blueMin = blueI
            alphaMin = alphaI
            
            for jIndex in (iIndex...(scene.playableGameboard.count-1)) {
                scene.playableGameboard[jIndex].square.fillColor.getRed(&redJ, green: &greenJ, blue: &blueJ, alpha: &alphaJ)
                let jValue = alphaJ
                
                let tempj = SkNodeLocationAndColor(square: scene.playableGameboard[jIndex].square, location: Tuple(x: scene.playableGameboard[jIndex].location.y, y: scene.playableGameboard[jIndex].location.x), color: UIColor(red: redJ, green: greenJ, blue: blueJ, alpha: alphaJ))
                pendingAnimations.append([tempj])
                
                if jValue < currentMinimumValue {
                    scene.playableGameboard[jIndex].square.fillColor.getRed(&redMin, green: &greenMin, blue: &blueMin, alpha: &alphaMin)
                    currentMinimumValue = jValue
                    currentMinimumIndex = jIndex
                }
            }
            let tempIValue = scene.playableGameboard[iIndex].square.fillColor
            scene.playableGameboard[iIndex].square.fillColor = scene.playableGameboard[currentMinimumIndex].square.fillColor
            scene.playableGameboard[currentMinimumIndex].square.fillColor = tempIValue
            
            let tempi = SkNodeLocationAndColor(square: scene.playableGameboard[iIndex].square, location: Tuple(x: scene.playableGameboard[iIndex].location.y, y: scene.playableGameboard[iIndex].location.x), color: UIColor(red: redMin, green: greenMin, blue: blueMin, alpha: alphaMin))
            
            let tempMin = SkNodeLocationAndColor(square: scene.playableGameboard[currentMinimumIndex].square, location: Tuple(x: scene.playableGameboard[currentMinimumIndex].location.y, y: scene.playableGameboard[currentMinimumIndex].location.x), color: UIColor(red: redI, green: greenI, blue: blueI, alpha: alphaI))
            
            pendingAnimations.append([tempMin, tempi])
        }
        
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
}
