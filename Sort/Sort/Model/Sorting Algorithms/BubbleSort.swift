//
//  BubbleSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 7/25/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

struct ColorAndLocation: Hashable {
    var color: UIColor
    var location: Tuple
}

class BubbleSort {
    weak var scene: GameScene!
    var swapSquareAndColor = [[SkNodeLocationAndColor]]()
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func bubbleSort(gameboard: [SkNodeAndLocation]) -> [[SkNodeLocationAndColor]] {
        let duplicateGameboard = gameboard
        var isSorted = false
        
        var tempStructure: [ColorAndLocation] = []
        for i in scene.gameBoard {
            tempStructure.append(ColorAndLocation(color: i.square.fillColor, location: i.location))
        }

        while (!isSorted) {
            isSorted = true
            for i in 0...((scene!.gameBoard.count)-scene.columnCount-3) {
                if duplicateGameboard[i].location.x != 0 && duplicateGameboard[i].location.x != (scene.rowCount - 1) {
                    if duplicateGameboard[i].location.y != 0 && duplicateGameboard[i].location.y != (scene.columnCount - 1) {
                        var ii = i+1

                        var validNextSquare = false
                        while validNextSquare == false {
                            if duplicateGameboard[ii].location.y == (scene.columnCount - 1) || duplicateGameboard[ii].location.y == 0 {
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

                        duplicateGameboard[i].square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                        duplicateGameboard[ii].square.fillColor.getRed(&redTwo, green: &greenTwo, blue: &blueTwo, alpha: &alphaTwo)


                        if alphaOne < alphaTwo {
                            duplicateGameboard[i].square.fillColor = UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo)
                            duplicateGameboard[ii].square.fillColor = UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne)

                            let tempi = SkNodeLocationAndColor(square: duplicateGameboard[i].square, location: Tuple(x: duplicateGameboard[i].location.y, y: duplicateGameboard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                            let tempii = SkNodeLocationAndColor(square: duplicateGameboard[ii].square, location: Tuple(x: duplicateGameboard[ii].location.y, y: duplicateGameboard[ii].location.x), color: UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne))
                            swapSquareAndColor.append([tempi, tempii])

                            isSorted = false
                        } else {
                            let tempi = SkNodeLocationAndColor(square: duplicateGameboard[i].square, location: Tuple(x: duplicateGameboard[i].location.y, y: duplicateGameboard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                            swapSquareAndColor.append([tempi])
                        }
                    }
                }
            }
        }
        
        for (index, i) in (scene.gameBoard).enumerated() {
            i.square.fillColor = tempStructure[index].color
        }
        
        for i in gameboard {
            print(i.square.fillColor)
        }
        
        return swapSquareAndColor
    }
}
