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
        let playableGameboard = scene.playableGameboard
//        var isSorted = false
        var currentMinimumValue = CGFloat()
        var currentMinimumIndex = 0
        
        var tempStructure: [UIColor] = []
        for i in scene.gameBoard {
            tempStructure.append(i.square.fillColor)
        }
        
        for (iIndex, _) in playableGameboard.enumerated() {
//            isSorted = true
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
            
            playableGameboard[iIndex].square.fillColor.getRed(&redI, green: &greenI, blue: &blueI, alpha: &alphaI)
            currentMinimumValue = alphaI
            currentMinimumIndex = iIndex
            redMin = redI
            greenMin = greenI
            blueMin = blueI
            alphaMin = alphaI
            
            for jIndex in (iIndex...(playableGameboard.count-1)) {
//                for jIndex in (iIndex...(playableGameboard.count-1)) {
//                    print(playableGameboard[jIndex].square.fillColor)
//                }
//                print("---")
                playableGameboard[jIndex].square.fillColor.getRed(&redJ, green: &greenJ, blue: &blueJ, alpha: &alphaJ)
                let jValue = alphaJ
                if jValue < currentMinimumValue {
                    playableGameboard[jIndex].square.fillColor.getRed(&redMin, green: &greenMin, blue: &blueMin, alpha: &alphaMin)
                    currentMinimumValue = jValue
                    currentMinimumIndex = jIndex
                    
                    let tempj = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: Tuple(x: playableGameboard[jIndex].location.y, y: playableGameboard[jIndex].location.x), color: UIColor(red: redJ, green: greenJ, blue: blueJ, alpha: alphaJ))
                    swapSquareAndColor.append([tempj])
                }
            }
            let tempIValue = playableGameboard[iIndex].square.fillColor
//            print("temp", tempIValue)
            playableGameboard[iIndex].square.fillColor = playableGameboard[currentMinimumIndex].square.fillColor
//            print("i", playableGameboard[iIndex].square.fillColor)
            playableGameboard[currentMinimumIndex].square.fillColor = tempIValue
//            print("min after swap", playableGameboard[currentMinimumIndex].square.fillColor)
            
//            for jIndex in (0...(playableGameboard.count-1)) {
//                print(playableGameboard[jIndex].square.fillColor)
//            }
//            print("-")
            
            let tempi = SkNodeLocationAndColor(square: playableGameboard[iIndex].square, location: Tuple(x: playableGameboard[iIndex].location.y, y: playableGameboard[iIndex].location.x), color: UIColor(red: redMin, green: greenMin, blue: blueMin, alpha: alphaMin))
//
            let tempMin = SkNodeLocationAndColor(square: playableGameboard[currentMinimumIndex].square, location: Tuple(x: playableGameboard[currentMinimumIndex].location.y, y: playableGameboard[currentMinimumIndex].location.x), color: UIColor(red: redI, green: greenI, blue: blueI, alpha: alphaI))
//            print(tempi.color, tempMin.color)
//            print(tempi.square.fillColor, tempMin.square.fillColor)
//            print(tempi.location, tempMin.location)
//
//            for i in (0...(playableGameboard.count-1)) {
//                print("loop", playableGameboard[i].square.fillColor)
//            }
            
            swapSquareAndColor.append([tempMin, tempi])
        }
        
        if resuming == false {
            for (index, i) in (scene.playableGameboard).enumerated() {
                if i.location.x != 0 && i.location.x != (scene.rowCount - 1) {
                    if i.location.y != 0 && i.location.y != (scene.columnCount - 1) {
                        i.square.fillColor = scene.gameboardSquareColor
                    }
                }
            }
        } else {
            for (index, i) in (scene.playableGameboard).enumerated() {
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
