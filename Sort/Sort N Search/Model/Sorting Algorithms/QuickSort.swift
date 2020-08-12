//
//  QuickSort.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/7/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class QuickSort {
    weak var scene: GameScene!
    var pendingAnimations = [[SkNodeLocationAndColor]]()
    
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
    
    func quickSortHelper(resuming: Bool) -> [[SkNodeLocationAndColor]]{
        // Save the gameboard apperiance before animations.
        let initialGameboardLayout = initialGameBoardAperianceSaver()
        // Run Quick sort on the graph.
        quickSort(array: scene.playableGameboard, frontPointer: 0, endPointer: scene.playableGameboard.count-1)
        // Restores grid back to pre-sort apperiance before return.
        initialGameBoardAperianceRestorer(resuming: resuming, initialGameboardLayout: initialGameboardLayout)
        return pendingAnimations
    }
    
    func quickSort(array: [SkNodeAndLocation], frontPointer: Int, endPointer: Int) {
        let playableGameboard = array
        
        if frontPointer == endPointer {
            return
        } else if endPointer < frontPointer {
            return
        }
        
        let pivotValue = medianOfMedians(array: playableGameboard, frontPointer: frontPointer, endPointer: endPointer)
        let pivotAlpha = pivotValue.square.fillColor.toComponents().alpha
        let pivotColor = pivotValue.square.fillColor
        
        var jIndex = frontPointer
        var iIndex = frontPointer-1
        
        for _ in (frontPointer...(endPointer-1)) {
            if jIndex < (playableGameboard.count-1) {
                let jIndexColorAlpha = playableGameboard[jIndex].square.fillColor.toComponents().alpha
                let jIndexColor = playableGameboard[jIndex].square.fillColor
                if jIndexColorAlpha < pivotAlpha {
                    iIndex += 1
                    let tempIValue = playableGameboard[iIndex].square.fillColor
                    playableGameboard[iIndex].square.fillColor = playableGameboard[jIndex].square.fillColor
                    playableGameboard[jIndex].square.fillColor = tempIValue
                    
                    let newIIndex = SkNodeLocationAndColor(square: playableGameboard[iIndex].square, location: playableGameboard[iIndex].location, color: jIndexColor)
                    let newJIndex = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: playableGameboard[jIndex].location, color: tempIValue)
                    pendingAnimations.append([newJIndex, newIIndex])
                } else {
                    let newJIndex = SkNodeLocationAndColor(square: playableGameboard[jIndex].square, location: playableGameboard[jIndex].location, color: playableGameboard[jIndex].square.fillColor)
                    pendingAnimations.append([newJIndex])
                }
                jIndex += 1
            }
        }
        let finalPivotValue = playableGameboard[iIndex+1].square.fillColor
        playableGameboard[iIndex+1].square.fillColor = pivotColor
        playableGameboard[endPointer].square.fillColor = finalPivotValue
        
        let newIPlusOneColor = SkNodeLocationAndColor(square: playableGameboard[iIndex+1].square, location: playableGameboard[iIndex+1].location, color: pivotColor)
        let newEndPointerColor = SkNodeLocationAndColor(square: playableGameboard[endPointer].square, location: playableGameboard[endPointer].location, color: finalPivotValue)
        pendingAnimations.append([newEndPointerColor, newIPlusOneColor])
        
        if endPointer-1 != frontPointer {
            quickSort(array: playableGameboard, frontPointer: frontPointer, endPointer: iIndex)
            quickSort(array: playableGameboard, frontPointer: iIndex+2, endPointer: endPointer)
        }
    }
    
    func medianOfMedians(array: [SkNodeAndLocation], frontPointer: Int, endPointer: Int) -> SkNodeAndLocation {
        
        if (endPointer - frontPointer) < 5 {
//            quickSort(array: scene.playableGameboard, frontPointer: frontPointer, endPointer: endPointer)
//            let median = Int(ceil((Float(endPointer) - Float(frontPointer))/2))
//            print(array[median])
            return array[endPointer]
        }
        
        var mediansAlphas = [CGFloat]()
        var mediansObjects = [SkNodeAndLocation]()
        var lastChunckEnd = frontPointer
        
        while (lastChunckEnd + 4) < endPointer {
            let currentChunkEnd = lastChunckEnd + 4
            quickSort(array: scene.playableGameboard, frontPointer: lastChunckEnd, endPointer: currentChunkEnd)
            mediansAlphas.append(array[lastChunckEnd+2].square.fillColor.toComponents().alpha)
            mediansObjects.append(array[lastChunckEnd+2])
            lastChunckEnd = currentChunkEnd+1
        }
        

        quickSort(array: mediansObjects, frontPointer: 0, endPointer: mediansAlphas.count-1)
//        print(medians)
//        print(array)
//        print(array[Int(ceil(Float(medians.count)/2))])
        
        if mediansObjects.count == 1 {
            return mediansObjects[0]
        } else {
            return mediansObjects[Int(ceil(Float(mediansAlphas.count)/2))-1]
        }
    }
}
