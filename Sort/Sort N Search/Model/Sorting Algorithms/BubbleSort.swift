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
    var swapSquareAndColor = [[SkNodeLocationAndColor]]()
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func bubbleSort(resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var isSorted = false
        
        var tempStructure: [UIColor] = []
        for i in scene.gameBoard {
            tempStructure.append(i.square.fillColor)
        }

        while (!isSorted) {
            isSorted = true
            for (i, _) in scene.playableGameboard.enumerated() {
                if i != (scene.playableGameboard.count-1) {
                    var ii = i+1

                    var redOne: CGFloat = 0
                    var greenOne: CGFloat = 0
                    var blueOne: CGFloat = 0
                    var alphaOne: CGFloat = 0
                    var redTwo: CGFloat = 0
                    var greenTwo: CGFloat = 0
                    var blueTwo: CGFloat = 0
                    var alphaTwo: CGFloat = 0

                    scene.playableGameboard[i].square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                    scene.playableGameboard[ii].square.fillColor.getRed(&redTwo, green: &greenTwo, blue: &blueTwo, alpha: &alphaTwo)


                    if alphaOne < alphaTwo {
                        scene.playableGameboard[i].square.fillColor = UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo)
                        scene.playableGameboard[ii].square.fillColor = UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne)

                        let tempi = SkNodeLocationAndColor(square: scene.playableGameboard[i].square, location: Tuple(x: scene.playableGameboard[i].location.y, y: scene.playableGameboard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                        let tempii = SkNodeLocationAndColor(square: scene.playableGameboard[ii].square, location: Tuple(x: scene.playableGameboard[ii].location.y, y: scene.playableGameboard[ii].location.x), color: UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne))
                        swapSquareAndColor.append([tempi, tempii])

                        isSorted = false
                    } else {
                        let tempi = SkNodeLocationAndColor(square: scene.playableGameboard[i].square, location: Tuple(x: scene.playableGameboard[i].location.y, y: scene.playableGameboard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                        swapSquareAndColor.append([tempi])
                    }
                }
            }
        }
        
        // Prevents sorted array grid from appering before initial animations begin.
        // If animation has to restart, prevents sorted array grid from apperaing before animations begin.
        if resuming == false {
            for i in scene.playableGameboard {
                i.square.fillColor = scene.gameboardSquareColor
            }
        } else {
            for (index, i) in (scene.gameBoard).enumerated() {
                if i.location.x != 0 && i.location.x != (scene.rowCount - 1) {
                    if i.location.y != 0 && i.location.y != (scene.columnCount - 1) {
                        i.square.fillColor = tempStructure[index]
                    }
                }
            }
        }
        
        return swapSquareAndColor
    }
}
