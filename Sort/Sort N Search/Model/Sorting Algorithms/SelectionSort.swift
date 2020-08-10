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

    func selectionSort(resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var pendingAnimations = [[SkNodeLocationAndColor]]()
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        
        for (iIndex, _) in scene.playableGameboard.enumerated() {
            let iColor = scene.playableGameboard[iIndex].square.fillColor
            var currentMinimumColor = iColor
            var currentMinimumAlpha = iColor.toComponents().alpha
            var currentMinimumIndex = iIndex
            
            for jIndex in (iIndex...(scene.playableGameboard.count-1)) {
                // No swap added to animation.
                let newJ = SkNodeLocationAndColor(square: scene.playableGameboard[jIndex].square, location: scene.playableGameboard[jIndex].location, color: scene.playableGameboard[jIndex].square.fillColor)
                pendingAnimations.append([newJ])
                
                let jColorAlpha = scene.playableGameboard[jIndex].square.fillColor.toComponents().alpha
                if jColorAlpha < currentMinimumAlpha {
                    currentMinimumColor = scene.playableGameboard[jIndex].square.fillColor
                    currentMinimumAlpha = jColorAlpha
                    currentMinimumIndex = jIndex
                }
            }
            // Swap square colors on phisical board data structure for Selection sort.
            let tempIValue = scene.playableGameboard[iIndex].square.fillColor
            scene.playableGameboard[iIndex].square.fillColor = scene.playableGameboard[currentMinimumIndex].square.fillColor
            scene.playableGameboard[currentMinimumIndex].square.fillColor = tempIValue
            
            // Swap square colors for animation data structure.
            let newI = SkNodeLocationAndColor(square: scene.playableGameboard[iIndex].square, location: scene.playableGameboard[iIndex].location, color: currentMinimumColor)
            let newMin = SkNodeLocationAndColor(square: scene.playableGameboard[currentMinimumIndex].square, location: scene.playableGameboard[currentMinimumIndex].location, color: iColor)
            pendingAnimations.append([newMin, newI])
        }
        
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
}
