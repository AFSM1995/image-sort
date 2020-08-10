//
//  BubbleSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 7/25/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class BubbleSort {
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
    
    func bubbleSort(resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var pendingAnimations = [[SkNodeLocationAndColor]]()
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        var isSorted = false

        // Is sorted can be used for step mode.
        while (!isSorted) {
            isSorted = true
            for (i, _) in scene.playableGameboard.enumerated() {
                if i != (scene.playableGameboard.count-1) {
                    let iPlusOne = i+1
                    let iColorComponents = scene.playableGameboard[i].square.fillColor.toComponents()
                    let iPlusOneColorComponents = scene.playableGameboard[iPlusOne].square.fillColor.toComponents()

                    if iColorComponents.alpha < iPlusOneColorComponents.alpha {
                        // Swap square colors on phisical board data structure for Bubble sort.
                        let tempIColor = scene.playableGameboard[i].square.fillColor
                        scene.playableGameboard[i].square.fillColor = scene.playableGameboard[iPlusOne].square.fillColor
                        scene.playableGameboard[iPlusOne].square.fillColor = tempIColor

                        // Swap square colors for animation data structure.
                        let newI = SkNodeLocationAndColor(square: scene.playableGameboard[i].square, location: scene.playableGameboard[i].location, color: scene.playableGameboard[i].square.fillColor)
                        let newIPlusOne = SkNodeLocationAndColor(square: scene.playableGameboard[iPlusOne].square, location: scene.playableGameboard[iPlusOne].location, color: tempIColor)
                        pendingAnimations.append([newI, newIPlusOne])

                        isSorted = false
                    } else {
                        // No swap added to animation.
                        let newI = SkNodeLocationAndColor(square: scene.playableGameboard[i].square, location: scene.playableGameboard[i].location, color: scene.playableGameboard[i].square.fillColor)
                        pendingAnimations.append([newI])
                    }
                }
            }
        }
        
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
}
