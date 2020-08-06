//
//  SelectionSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/5/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class SelectionSort {
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }

    func selectionSort(gameboard: [SkNodeAndLocation], resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var swapSquareAndColor = [[SkNodeLocationAndColor]]()
        var isSorted = false
        var currentMinimumValue = UIColor()
        var currentMinimumIndex = 0
        var playableGameboard = scene.playableGameboard
        var tempi: SkNodeLocationAndColor
        var tempj: SkNodeLocationAndColor
        var min: SkNodeLocationAndColor
        
        var tempStructure: [UIColor] = []
        for i in scene.gameBoard {
            tempStructure.append(i.square.fillColor)
        }
        
        for (iIndex, _) in playableGameboard.enumerated() {
            isSorted = true
            
            var redOne: CGFloat = 0
            var greenOne: CGFloat = 0
            var blueOne: CGFloat = 0
            var alphaOne: CGFloat = 0
            var redTwo: CGFloat = 0
            var greenTwo: CGFloat = 0
            var blueTwo: CGFloat = 0
            var alphaTwo: CGFloat = 0
            var redThree: CGFloat = 0
            var greenThree: CGFloat = 0
            var blueThree: CGFloat = 0
            var alphaThree: CGFloat = 0
            
            currentMinimumValue = playableGameboard[iIndex].square.fillColor
            currentMinimumIndex = iIndex
            for jIndex in (iIndex...(playableGameboard.count-1)) {
                playableGameboard[iIndex].square.fillColor = UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne)
                playableGameboard[jIndex].square.fillColor = UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo)
                playableGameboard[currentMinimumIndex].square.fillColor = UIColor(red: redThree, green: greenThree, blue: blueThree, alpha: alphaThree)
                
                tempi = SkNodeLocationAndColor(square: playableGameboard[iIndex].square, location: Tuple(x: playableGameboard[iIndex].location.y, y: playableGameboard[iIndex].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                tempj = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: Tuple(x: playableGameboard[jIndex].location.y, y: playableGameboard[jIndex].location.x), color: UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne))
                min = SkNodeLocationAndColor(square: playableGameboard[currentMinimumIndex].square, location: Tuple(x: playableGameboard[currentMinimumIndex].location.y, y: playableGameboard[currentMinimumIndex].location.x), color: UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne))
                
                isSorted = false
                
                let jValue = playableGameboard[jIndex].square.fillColor
                if alphaTwo < alphaThree {
                    currentMinimumValue = playableGameboard[jIndex].square.fillColor
                    currentMinimumIndex = jIndex
                    swapSquareAndColor.append([tempi, min])
                }
            }
            let tempIValue = playableGameboard[iIndex]
            playableGameboard[iIndex] = playableGameboard[currentMinimumIndex]
            playableGameboard[currentMinimumIndex] = tempIValue
            
            isSorted = false
        }
        return swapSquareAndColor
    }
}
