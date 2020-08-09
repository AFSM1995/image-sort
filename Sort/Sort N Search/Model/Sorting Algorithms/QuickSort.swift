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
            
            var redP: CGFloat = 1
            var greenP: CGFloat = 1
            var blueP: CGFloat = 1
            var alphaP: CGFloat = 1
            var redJ: CGFloat = 1
            var greenJ: CGFloat = 1
            var blueJ: CGFloat = 1
            var alphaJ: CGFloat = 1
            let fullPivotColor = (playableGameboard[endPointer]).square.fillColor
            (playableGameboard[endPointer]).square.fillColor.getRed(&redP, green: &greenP, blue: &blueP, alpha: &alphaP)
            let pivot = alphaP
            var jIndex = frontPointer
            var iIndex = frontPointer-1
            
            
            for _ in (0...(endPointer-1)) {
                if jIndex < (playableGameboard.count-1) {
                    playableGameboard[jIndex].square.fillColor.getRed(&redJ, green: &greenJ, blue: &blueJ, alpha: &alphaJ)
                    for i in playableGameboard {
                        print(i.square.fillColor)
                    }
                    if alphaJ < alphaP {
                        iIndex += 1
                        let tempIValue = playableGameboard[iIndex].square.fillColor
                        playableGameboard[iIndex].square.fillColor = playableGameboard[jIndex].square.fillColor
                        playableGameboard[jIndex].square.fillColor = tempIValue
                        print("sdfg", playableGameboard[iIndex].square.fillColor, playableGameboard[jIndex].square.fillColor)
                        
                        var redIII: CGFloat = 1
                        var greenIII: CGFloat = 1
                        var blueIII: CGFloat = 1
                        var alphaIII: CGFloat = 1
                        playableGameboard[iIndex].square.fillColor.getRed(&redIII, green: &greenIII, blue: &blueIII, alpha: &alphaIII)
                        let tempjj = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: Tuple(x: playableGameboard[jIndex].location.y, y: playableGameboard[jIndex].location.x), color: UIColor(red: redIII, green: greenIII, blue: blueIII, alpha: alphaIII))
                        
                        var redJJJ: CGFloat = 1
                        var greenJJJ: CGFloat = 1
                        var blueJJJ: CGFloat = 1
                        var alphaJJJ: CGFloat = 1
                        playableGameboard[jIndex].square.fillColor.getRed(&redJJJ, green: &greenJJJ, blue: &blueJJJ, alpha: &alphaJJJ)
                        let tempii = SkNodeLocationAndColor(square: playableGameboard[iIndex].square, location: Tuple(x: playableGameboard[iIndex].location.y, y: playableGameboard[iIndex].location.x), color: UIColor(red: redJJJ, green: greenJJJ, blue: blueJJJ, alpha: alphaJJJ))
                        

                        print("Inner S", "j", tempjj.color, "i", tempii.color)
                        for i in playableGameboard {
                            print(i.square.fillColor)
                        }
                        print("-----")
                        swapSquareAndColor.append([tempii, tempjj])
                    } else {
                        let tempjj = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: Tuple(x: playableGameboard[jIndex].location.y, y: playableGameboard[jIndex].location.x), color: UIColor(red: redJ, green: greenJ, blue: blueJ, alpha: alphaJ))
                        print(jIndex, alphaJ)
                        swapSquareAndColor.append([tempjj])
                    }
                    jIndex += 1
                }
            }
            
            // i j min mix up
            let finalPivotValue = playableGameboard[iIndex+1].square.fillColor
            playableGameboard[iIndex+1].square.fillColor = fullPivotColor
            playableGameboard[endPointer].square.fillColor = finalPivotValue
            
            // maybe color swap
            let tempiPlusOne = SkNodeLocationAndColor(square: playableGameboard[iIndex+1].square, location: Tuple(x: playableGameboard[iIndex+1].location.y, y: playableGameboard[iIndex+1].location.x), color: fullPivotColor)
            
            let tempEnd = SkNodeLocationAndColor(square: playableGameboard[endPointer].square, location: Tuple(x: playableGameboard[endPointer].location.y, y: playableGameboard[endPointer].location.x), color: finalPivotValue)
            
            swapSquareAndColor.append([tempEnd, tempiPlusOne])
            
            if (endPointer - 1 != frontPointer) {
                quickSort(frontPointer: frontPointer, endPointer: iIndex)
                quickSort(frontPointer: iIndex+2, endPointer: endPointer)
            }
        }
        
        quickSort(frontPointer: 0, endPointer: scene.playableGameboard.count-1)
        return swapSquareAndColor
    }
}
