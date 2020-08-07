//
//  InsertionSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/4/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class InsertionSort {
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }

    func insertionSort(gameboard: [SkNodeAndLocation], resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var swapSquareAndColor = [[SkNodeLocationAndColor]]()
        var isSorted = false
        
        var tempStructure: [UIColor] = []
        for i in scene.gameBoard {
            tempStructure.append(i.square.fillColor)
        }
        
        for (i, _) in scene.playableGameboard.enumerated() {
            let playableGameboard = scene.playableGameboard
            isSorted = true
            var j = i - 1
            var ii = i
            
            var redOne: CGFloat = 0
            var greenOne: CGFloat = 0
            var blueOne: CGFloat = 0
            var alphaOne: CGFloat = 0
            var redTwo: CGFloat = 0
            var greenTwo: CGFloat = 0
            var blueTwo: CGFloat = 0
            var alphaTwo: CGFloat = 0

            if j != -1 && ii != -1 {
                playableGameboard[ii].square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                playableGameboard[j].square.fillColor.getRed(&redTwo, green: &greenTwo, blue: &blueTwo, alpha: &alphaTwo)
            }
            
            while j != -1 && ii != -1 && alphaOne > alphaTwo {
                playableGameboard[ii].square.fillColor = UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo)
                playableGameboard[j].square.fillColor = UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne)
                
                let tempi = SkNodeLocationAndColor(square: playableGameboard[ii].square, location: Tuple(x: playableGameboard[ii].location.y, y: playableGameboard[ii].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                let tempj = SkNodeLocationAndColor(square: playableGameboard[j].square, location: Tuple(x: playableGameboard[j].location.y, y: playableGameboard[j].location.x), color: UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne))
                swapSquareAndColor.append([tempi, tempj])
                
                isSorted = false
                
                j = j - 1
                ii = ii - 1
                if j != -1 && ii != -1 {
                    playableGameboard[ii].square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                    playableGameboard[j].square.fillColor.getRed(&redTwo, green: &greenTwo, blue: &blueTwo, alpha: &alphaTwo)
                }
            }
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
