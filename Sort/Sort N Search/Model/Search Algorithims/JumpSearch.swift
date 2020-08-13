//
//  JumpSearch.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/13/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

let array = [0,1,1,2,3,5,8,13,21,34,55,77,89,91,95,110]

func jumpSort(targetValue: Int) {
    let jumpSize = (Int(ceil(sqrt(Float(array.count)))) - 1)
    var currentJumpLocation = 0
    var nextJumpLocation = (currentJumpLocation + jumpSize)
    var currentJumpLocationValue = array[currentJumpLocation]
    var nextJumpLocationValue = array[nextJumpLocation]
    var found = false
    var targetLocation: Int
    
    if currentJumpLocationValue == targetValue {
        found = true
        targetLocation = currentJumpLocation
        print(targetLocation)
    }
    
    while found != true {
        if nextJumpLocationValue == targetValue {
            found = true
            targetLocation = nextJumpLocation
            print(targetLocation)
        } else if nextJumpLocationValue > targetValue || nextJumpLocation >= array.count {
            for i in currentJumpLocation...(nextJumpLocation-1) {
                if array[i] == targetValue {
                    found = true
                    targetLocation = i
                    print(targetLocation)
                    break
                }
            }
            break
        } else if nextJumpLocationValue < targetValue {
            if (nextJumpLocation + jumpSize) >= array.count {
                break
            }
            currentJumpLocation = nextJumpLocation
            currentJumpLocationValue = array[currentJumpLocation]
            nextJumpLocation = (currentJumpLocation + jumpSize)
            nextJumpLocationValue = array[nextJumpLocation]
        }
    }
    
    if found == false {
        targetLocation = -1
        print(targetLocation)
    }
}

jumpSort(targetValue: 89)
