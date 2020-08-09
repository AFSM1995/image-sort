//
//  BubbleSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 7/25/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

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
        var swapSquareAndColor = [[SkNodeLocationAndColor]]()
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        var isSorted = false

        // Is sorted can be used for step mode.
        while (!isSorted) {
            isSorted = true
            for (i, _) in scene.playableGameboard.enumerated() {
                if i != (scene.playableGameboard.count-1) {
                    let iPlusOne = i+1
                    let iColor = scene.playableGameboard[i].square.fillColor
                    let iPlusOneColor = scene.playableGameboard[iPlusOne].square.fillColor
                    let iColorComponents = scene.playableGameboard[i].square.fillColor.toComponents()
                    let iPlusOneColorComponents = scene.playableGameboard[iPlusOne].square.fillColor.toComponents()

                    if iColorComponents.alpha < iPlusOneColorComponents.alpha {
                        scene.playableGameboard[i].square.fillColor = UIColor(red: iPlusOneColorComponents.red, green: iPlusOneColorComponents.green, blue: iPlusOneColorComponents.blue, alpha: iPlusOneColorComponents.alpha)
                        scene.playableGameboard[iPlusOne].square.fillColor = UIColor(red: iColorComponents.red, green: iColorComponents.green, blue: iColorComponents.blue, alpha: iColorComponents.alpha)

                        let tempi = SkNodeLocationAndColor(square: scene.playableGameboard[i].square, location: Tuple(x: scene.playableGameboard[i].location.y, y: scene.playableGameboard[i].location.x), color: iPlusOneColor)
                        let tempii = SkNodeLocationAndColor(square: scene.playableGameboard[iPlusOne].square, location: Tuple(x: scene.playableGameboard[iPlusOne].location.y, y: scene.playableGameboard[iPlusOne].location.x), color: iColor)
                        swapSquareAndColor.append([tempi, tempii])

                        isSorted = false
                    } else {
                        let tempi = SkNodeLocationAndColor(square: scene.playableGameboard[i].square, location: Tuple(x: scene.playableGameboard[i].location.y, y: scene.playableGameboard[i].location.x), color: iPlusOneColor)
                        swapSquareAndColor.append([tempi])
                    }
                }
            }
        }
        
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return swapSquareAndColor
    }
}
