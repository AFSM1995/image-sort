//
//  BinarySearch.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

let array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
var iterations: [[Int]] = []

func binarySearch(targetArray: [Int], target: Int, frontPointer: Int, tailPointer: Int) -> Int {
    let center = Int((tailPointer - frontPointer)/2)
    iterations.append([frontPointer,center,tailPointer])
    var result = -1
    
    if target > array[(array.count - 1)] || target < array[0] {
        return -1
    }
    
    if array[center] == target {
        return center
    } else if (array[frontPointer] == target) {
        return frontPointer
    } else if (array[tailPointer] == target) {
        return tailPointer
    } else if array[center] > target {
        result = binarySearch(targetArray: array, target: target, frontPointer: frontPointer+1, tailPointer: center-1)
    } else if array[center] < target {
        result = binarySearch(targetArray: array, target: target, frontPointer: center+1, tailPointer: tailPointer-1)
    } else if ((frontPointer+1) == center) {
        return -1
    }
    return result
}
