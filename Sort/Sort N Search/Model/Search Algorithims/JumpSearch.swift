//
//  JumpSearch.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/13/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class JumpSearch {
    weak var scene: GameScene!
    var searchTargetSquare: [SkNodeAndLocation] = []
    var searchHistory: [SkNodeAndLocation] = []
    var targetSquareFound = false
    var playableGameboard: [SkNodeAndLocation] = []
    var playableGameBoardSize = Int()

    init(scene: GameScene) {
        self.scene = scene
        playableGameboard = scene.playableGameboard
        playableGameBoardSize = scene.playableGameboard.count
    }

    func jumpSearch(targetArray: [Float], targetValue: Float) -> ([SkNodeAndLocation], Bool, [SkNodeAndLocation]) {
        let jumpSize = (Int(ceil(sqrt(Float(targetArray.count)))) - 1)
    //    print("jump Size", jumpSize)
        var currentJumpLocation = 0
        var nextJumpLocation = (currentJumpLocation + jumpSize)
        var currentJumpLocationValue = targetArray[currentJumpLocation]
        var nextJumpLocationValue = targetArray[nextJumpLocation]
        var found = false
        
    //    print("explored", currentJumpLocationValue)
        if currentJumpLocationValue == targetValue {
            found = true
            targetLocation = currentJumpLocation
    //        print(targetLocation)
        }
        
        while found != true {
    //        print("explored", nextJumpLocationValue)
            if nextJumpLocationValue == targetValue {
                found = true
                targetLocation = nextJumpLocation
    //            print(targetLocation)
            }
    //        print("explored", nextJumpLocationValue)
            if nextJumpLocationValue > targetValue || nextJumpLocation >= targetArray.count {
                for i in currentJumpLocation...(nextJumpLocation-1) {
    //                print("explored", targetArray[i])
                    if targetArray[i] == targetValue {
                        found = true
                        targetLocation = i
    //                    print(targetLocation)
                        break
                    }
                }
                break
            }
    //        print("explored", nextJumpLocationValue)
            if nextJumpLocationValue < targetValue {
                if (nextJumpLocation + jumpSize) >= targetArray.count {
                    for i in nextJumpLocation...(targetArray.count-1) {
    //                    print("explored", targetArray[i])
                        if targetArray[i] == targetValue {
                            found = true
                            targetLocation = i
    //                        print(targetLocation)
                            break
                        }
                    }
                    break
                }
                currentJumpLocation = nextJumpLocation
                currentJumpLocationValue = targetArray[currentJumpLocation]
                nextJumpLocation = (currentJumpLocation + jumpSize)
                nextJumpLocationValue = targetArray[nextJumpLocation]
            }
        }
        
        if found == false {
            targetLocation = -1
//            print(targetLocation)
            return (searchHistory, targetFound, target)
        }
        return (searchHistory, targetFound, target)
    }
}
