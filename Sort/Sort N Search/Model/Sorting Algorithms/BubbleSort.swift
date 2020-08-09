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
    
    func bubbleSort(gameboard: [SkNodeAndLocation], resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var isSorted = false
        
        var tempStructure: [UIColor] = []
        for i in scene.gameBoard {
            tempStructure.append(i.square.fillColor)
        }

        while (!isSorted) {
            isSorted = true
            for i in 0...((scene!.gameBoard.count)-scene.columnCount-3) {
                if gameboard[i].location.x != 0 && gameboard[i].location.x != (scene.rowCount - 1) {
                    if gameboard[i].location.y != 0 && gameboard[i].location.y != (scene.columnCount - 1) {
                        var ii = i+1

                        var validNextSquare = false
                        while validNextSquare == false {
                            if gameboard[ii].location.y == (scene.columnCount - 1) || gameboard[ii].location.y == 0 {
                                ii += 1
                            } else {
                                validNextSquare = true
                            }
                        }

                        var redOne: CGFloat = 0
                        var greenOne: CGFloat = 0
                        var blueOne: CGFloat = 0
                        var alphaOne: CGFloat = 0
                        var redTwo: CGFloat = 0
                        var greenTwo: CGFloat = 0
                        var blueTwo: CGFloat = 0
                        var alphaTwo: CGFloat = 0

                        gameboard[i].square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                        gameboard[ii].square.fillColor.getRed(&redTwo, green: &greenTwo, blue: &blueTwo, alpha: &alphaTwo)


                        if alphaOne < alphaTwo {
                            gameboard[i].square.fillColor = UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo)
                            gameboard[ii].square.fillColor = UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne)

                            let tempi = SkNodeLocationAndColor(square: gameboard[i].square, location: Tuple(x: gameboard[i].location.y, y: gameboard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                            let tempii = SkNodeLocationAndColor(square: gameboard[ii].square, location: Tuple(x: gameboard[ii].location.y, y: gameboard[ii].location.x), color: UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne))
                            swapSquareAndColor.append([tempi, tempii])

                            isSorted = false
                        } else {
                            let tempi = SkNodeLocationAndColor(square: gameboard[i].square, location: Tuple(x: gameboard[i].location.y, y: gameboard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                            swapSquareAndColor.append([tempi])
                        }
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
