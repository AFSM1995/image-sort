//
//  BinarySearch.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class BinarySearch {
    var iterations: [[Int]] = []
    weak var scene: GameScene!
    var swapSquareAndColor = [[SkNodeLocationAndColor]]()
    var searchTarget: [SkNodeAndLocation] = []
    var searchHistory: [SkNodeAndLocation] = []
    var targetFound = false
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func binarySearchHandler() -> ([SkNodeAndLocation], Bool, [SkNodeAndLocation]) {
        let qq = scene.playableGameboard
        let randomNum = Int.random(in: 1...7)
        searchTarget.append(qq[randomNum])
        let playableBoardSize = scene!.playableGameboard.count
        
        for (index, i) in (scene.playableGameboard).enumerated() {
            qq[index].square.name = String(index)
            print(scene.playableGameboard[index].location.x, scene.playableGameboard[index].location.y, "index", scene.playableGameboard[index].square.name)
        }
        
        let searchResult = BinarySearch(targetArray: scene!.playableGameboard, target: randomNum, frontPointer: 0, tailPointer: (playableBoardSize-1))
        return(searchHistory, targetFound, searchTarget)
    }
    
    func BinarySearch(targetArray: [SkNodeAndLocation], target: Int, frontPointer: Int, tailPointer: Int) -> Int {
        let center = Int((tailPointer - frontPointer)/2)
        let sdf = scene.playableGameboard
        searchHistory.append(sdf[frontPointer])
        searchHistory.append(sdf[center])
        searchHistory.append(sdf[tailPointer])
        var result = -1
        
//        if target > scene.playableGameboard[(scene.playableGameboard.count - 1)] || target < scene.playableGameboard[0] {
//            return -1
//        }
        
//        let s = sdf[center]
        
        if Int(sdf[center].square.name!) == target {
            return center
        } else if Int(sdf[frontPointer].square.name!) == target {
            return frontPointer
        } else if Int(sdf[tailPointer].square.name!) == target {
            return tailPointer
        } else if Int(sdf[center].square.name!)! > target {
            result = BinarySearch(targetArray: scene!.playableGameboard, target: target, frontPointer: frontPointer+1, tailPointer: center-1)
        } else if Int(sdf[center].square.name!)! < target {
            result = BinarySearch(targetArray: scene!.playableGameboard, target: target, frontPointer: center+1, tailPointer: tailPointer-1)
        } else if ((frontPointer+1) == center) {
            return -1
        }
        
        if result == target {
            targetFound = true
        }
        return result
    }
}
