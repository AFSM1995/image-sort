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
        var isSorted = false
        var currentMinimumValue = CGFloat()
        var currentMinimumIndex = 0
        
        for (iIndex, _) in playableGameboard.enumerated() {
            isSorted = true
            var redI: CGFloat = 0
            var greenI: CGFloat = 0
            var blueI: CGFloat = 0
            var alphaI: CGFloat = 0
            var redJ: CGFloat = 0
            var greenJ: CGFloat = 0
            var blueJ: CGFloat = 0
            var alphaJ: CGFloat = 0
            
            playableGameboard[iIndex].square.fillColor.getRed(&redI, green: &greenI, blue: &blueI, alpha: &alphaI)
            currentMinimumValue = alphaI
            currentMinimumIndex = iIndex
            for jIndex in (iIndex...(playableGameboard.count-1)) {
                playableGameboard[jIndex].square.fillColor.getRed(&redJ, green: &greenJ, blue: &blueJ, alpha: &alphaJ)
                let jValue = alphaJ
                if jValue < currentMinimumValue {
                    currentMinimumValue = alphaJ
                    currentMinimumIndex = jIndex
                    
                    let tempj = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: Tuple(x: playableGameboard[jIndex].location.y, y: playableGameboard[jIndex].location.x), color: UIColor(red: redJ, green: greenJ, blue: blueJ, alpha: alphaJ))
                    swapSquareAndColor.append([tempj])
                }
            }
            let tempIValue = playableGameboard[iIndex].square.fillColor
            playableGameboard[iIndex].square.fillColor = playableGameboard[currentMinimumIndex].square.fillColor
            playableGameboard[currentMinimumIndex].square.fillColor = tempIValue
            
            let tempi = SkNodeLocationAndColor(square: playableGameboard[iIndex].square, location: Tuple(x: playableGameboard[iIndex].location.y, y: playableGameboard[iIndex].location.x), color: UIColor(red: redI, green: greenI, blue: blueI, alpha: alphaI))
            
            let tempMin = SkNodeLocationAndColor(square: playableGameboard[currentMinimumIndex].square, location: Tuple(x: playableGameboard[currentMinimumIndex].location.y, y: playableGameboard[currentMinimumIndex].location.x), color: UIColor(red: redI, green: greenI, blue: blueI, alpha: alphaI))
            
            swapSquareAndColor.append([tempi, tempMin])
        }
        return swapSquareAndColor
    }
}
