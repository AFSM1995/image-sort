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
    
    func bubbleSort(gameBoard: [SkNodeAndLocation]) -> [[SkNodeLocationAndColor]] {
        var isSorted = false
        while (!isSorted) {
            isSorted = true
            for i in 0...((scene!.gameBoard.count)-scene.columnCount-3) {
                if gameBoard[i].location.x != 0 && gameBoard[i].location.x != (scene.rowCount - 1) {
                    if gameBoard[i].location.y != 0 && gameBoard[i].location.y != (scene.columnCount - 1) {
                        var ii = i+1
                        
                        var validNextSquare = false
                        while validNextSquare == false {
                            if gameBoard[ii].location.y == (scene.columnCount - 1) || gameBoard[ii].location.y == 0 {
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

                        gameBoard[i].square.fillColor.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
                        gameBoard[ii].square.fillColor.getRed(&redTwo, green: &greenTwo, blue: &blueTwo, alpha: &alphaTwo)
                        

                        if alphaOne < alphaTwo {
                            gameBoard[i].square.fillColor = UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo)
                            gameBoard[ii].square.fillColor = UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne)
                            
                            let tempi = SkNodeLocationAndColor(square: gameBoard[i].square, location: Tuple(x: gameBoard[i].location.y, y: gameBoard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                            let tempii = SkNodeLocationAndColor(square: gameBoard[ii].square, location: Tuple(x: gameBoard[ii].location.y, y: gameBoard[ii].location.x), color: UIColor(red: redOne, green: greenOne, blue: blueOne, alpha: alphaOne))
                            swapSquareAndColor.append([tempi, tempii])
                            
                            isSorted = false
                        } else {
                            let tempi = SkNodeLocationAndColor(square: gameBoard[i].square, location: Tuple(x: gameBoard[i].location.y, y: gameBoard[i].location.x), color: UIColor(red: redTwo, green: greenTwo, blue: blueTwo, alpha: alphaTwo))
                            swapSquareAndColor.append([tempi])
                        }
                    }
                }
            }
        }
        return swapSquareAndColor
    }
}
