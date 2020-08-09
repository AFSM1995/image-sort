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
        var currentMinimumAlpha = CGFloat()
        var currentMinimumIndex = 0
        
        for (iIndex, _) in scene.playableGameboard.enumerated() {
            let iColorComponents = scene.playableGameboard[iIndex].square.fillColor
            currentMinimumAlpha = iColorComponents.toComponents().alpha
            currentMinimumIndex = iIndex
            var minimumColor = iColorComponents
            
            for jIndex in (iIndex...(scene.playableGameboard.count-1)) {
                let newJ = SkNodeLocationAndColor(square: scene.playableGameboard[jIndex].square, location: scene.playableGameboard[jIndex].location, color: scene.playableGameboard[jIndex].square.fillColor)
                pendingAnimations.append([newJ])
                
                let jColorAlpha = scene.playableGameboard[jIndex].square.fillColor.toComponents().alpha
                if jColorAlpha < currentMinimumAlpha {
                    minimumColor = scene.playableGameboard[jIndex].square.fillColor
                    currentMinimumAlpha = jColorAlpha
                    currentMinimumIndex = jIndex
                }
            }
            let tempIValue = scene.playableGameboard[iIndex].square.fillColor
            scene.playableGameboard[iIndex].square.fillColor = scene.playableGameboard[currentMinimumIndex].square.fillColor
            scene.playableGameboard[currentMinimumIndex].square.fillColor = tempIValue
            
            let tempi = SkNodeLocationAndColor(square: scene.playableGameboard[iIndex].square, location: scene.playableGameboard[iIndex].location, color: minimumColor)
            let tempMin = SkNodeLocationAndColor(square: scene.playableGameboard[currentMinimumIndex].square, location: scene.playableGameboard[currentMinimumIndex].location, color: iColorComponents)
            
            pendingAnimations.append([tempMin, tempi])
        }
        
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
}
