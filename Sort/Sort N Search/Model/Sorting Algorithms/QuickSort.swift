//
//  QuickSort.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/7/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class QuickSort {
    weak var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func quickSortHelper(gameboard: [SkNodeAndLocation], resuming: Bool) -> [[SkNodeLocationAndColor]] {
        var swapSquareAndColor = [[SkNodeLocationAndColor]]()
        let playableGameboard = scene.playableGameboard
        
        var tempStructure: [UIColor] = []
        for i in scene.gameBoard {
            tempStructure.append(i.square.fillColor)
        }
        
        func quickSort(frontPointer: Int, endPointer: Int) {
            
            if frontPointer == endPointer {
                return
            } else if endPointer < frontPointer {
                return
            }
            
            var redP: CGFloat = 0
            var greenP: CGFloat = 0
            var blueP: CGFloat = 0
            var alphaP: CGFloat = 0
            var redJ: CGFloat = 0
            var greenJ: CGFloat = 0
            var blueJ: CGFloat = 0
            var alphaJ: CGFloat = 0
            let fullPivotColor = (playableGameboard[endPointer]).square.fillColor
            (playableGameboard[endPointer]).square.fillColor.getRed(&redP, green: &greenP, blue: &blueP, alpha: &alphaP)
            let pivot = alphaP
            var jIndex = frontPointer
            var iIndex = frontPointer-1
            
            for _ in (0...(endPointer-1)) {
                if jIndex < (playableGameboard.count-1) {
                    playableGameboard[jIndex].square.fillColor.getRed(&redJ, green: &greenJ, blue: &blueJ, alpha: &alphaJ)
                    if alphaJ < alphaP {
                        iIndex += 1
                        let tempIValue = playableGameboard[iIndex].square.fillColor
                        playableGameboard[iIndex].square.fillColor = playableGameboard[jIndex].square.fillColor
                        playableGameboard[jIndex].square.fillColor = tempIValue
                        
                    }
                    jIndex += 1
                }
            }
            // maybe color swap
            var redIP: CGFloat = 0
            var greenIP: CGFloat = 0
            var blueIP: CGFloat = 0
            var alphaIP: CGFloat = 0
            (playableGameboard[iIndex+1]).square.fillColor.getRed(&redIP, green: &greenIP, blue: &blueIP, alpha: &alphaIP)
            let tempi = SkNodeLocationAndColor(square: playableGameboard[iIndex+1].square, location: Tuple(x: playableGameboard[iIndex+1].location.y, y: playableGameboard[iIndex+1].location.x), color: UIColor(red: redIP, green: greenIP, blue: blueIP, alpha: alphaIP))
            
            var redEND: CGFloat = 0
            var greenEND: CGFloat = 0
            var blueEND: CGFloat = 0
            var alphaEND: CGFloat = 0
            (playableGameboard[endPointer]).square.fillColor.getRed(&redEND, green: &greenEND, blue: &blueEND, alpha: &alphaEND)
            let tempEnd = SkNodeLocationAndColor(square: playableGameboard[endPointer].square, location: Tuple(x: playableGameboard[endPointer].location.y, y: playableGameboard[endPointer].location.x), color: UIColor(red: redEND, green: greenEND, blue: blueEND, alpha: alphaEND))
            
            // i j min mix up
            let finalPivotValue = playableGameboard[iIndex+1].square.fillColor
            playableGameboard[iIndex+1].square.fillColor = fullPivotColor
            playableGameboard[endPointer].square.fillColor = finalPivotValue
            
            if (endPointer - 1 != frontPointer) {
                quickSort(frontPointer: frontPointer, endPointer: iIndex)
                quickSort(frontPointer: iIndex+2, endPointer: endPointer)
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
        
        for i in scene.playableGameboard {
            print(i.square.fillColor)
        }
        return swapSquareAndColor
    }
}
