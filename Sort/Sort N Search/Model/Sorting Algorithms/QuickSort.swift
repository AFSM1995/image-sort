//
//  QuickSort.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/7/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class QuickSort {
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
    
    func quickSortHelper(resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var pendingAnimations = [[SkNodeLocationAndColor]]()
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        let playableGameboard = scene.playableGameboard
        
        func quickSort(frontPointer: Int, endPointer: Int) {
            if frontPointer == endPointer {
                return
            } else if endPointer < frontPointer {
                return
            }
            
            let endPointerColor = playableGameboard[endPointer].square.fillColor
            let endPointerAlpha = playableGameboard[endPointer].square.fillColor.toComponents().alpha
            let fullPivotColor = endPointerColor
            var jIndex = frontPointer
            var iIndex = frontPointer-1
            
            
            for _ in (0...(endPointer-1)) {
                if jIndex < (playableGameboard.count-1) {
                    let jIndexColorAlpha = playableGameboard[jIndex].square.fillColor.toComponents().alpha
                    if jIndexColorAlpha < endPointerAlpha {
                        iIndex += 1
                        let tempIValue = playableGameboard[iIndex].square.fillColor
                        playableGameboard[iIndex].square.fillColor = playableGameboard[jIndex].square.fillColor
                        playableGameboard[jIndex].square.fillColor = tempIValue
                        
                        let newIIndex = SkNodeLocationAndColor(square: playableGameboard[iIndex].square, location: playableGameboard[iIndex].location, color: tempIValue)
                        let newJIndex = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: playableGameboard[jIndex].location, color: tempIValue)
                        pendingAnimations.append([newJIndex, newIIndex])
                    }
                    jIndex += 1
                    for i in scene.playableGameboard {
                        print(i.square.fillColor)
                    }
                    print("New")
                }
            }
            
            let newIPlusOneColor = SkNodeLocationAndColor(square: playableGameboard[iIndex+1].square, location: playableGameboard[iIndex+1].location, color: playableGameboard[iIndex+1].square.fillColor)
            let newEndPointerColor = SkNodeLocationAndColor(square: playableGameboard[endPointer].square, location: playableGameboard[endPointer].location, color: playableGameboard[endPointer].square.fillColor)
            pendingAnimations.append([newEndPointerColor, newIPlusOneColor])
            
            let finalPivotValue = playableGameboard[iIndex+1].square.fillColor
            playableGameboard[iIndex+1].square.fillColor = fullPivotColor
            playableGameboard[endPointer].square.fillColor = finalPivotValue
            
            if endPointer-1 != frontPointer {
                quickSort(frontPointer: frontPointer, endPointer: iIndex)
                quickSort(frontPointer: iIndex+2, endPointer: endPointer)
            }
        }
        
        quickSort(frontPointer: 0, endPointer: scene.playableGameboard.count-1)
        
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
}
