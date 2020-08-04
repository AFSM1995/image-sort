//
//  BinarySearch.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

let array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
let target = 1

func binarySearch(targetArray: [Int], target: Int, frontPointer: Int, tailPointer: Int) -> Int {
    let center = Int((tailPointer - frontPointer)/2)
    if array[center] == target {
        print("target", target, "index", center, "array value", array[center])
        return target
    } else if (array[frontPointer] == target) {
        print("front", frontPointer, "index", frontPointer, "array value", array[frontPointer])
        return frontPointer
    } else if (array[tailPointer] == target) {
        print("tail", tailPointer, "index", tailPointer, "array value", array[tailPointer])
        return tailPointer
    } else if array[center] > target {
        print("explore the left", frontPointer, center, tailPointer)
        binarySearch(targetArray: array, target: target, frontPointer: frontPointer+1, tailPointer: center-1)
    } else if array[center] < target {
        print("explore the right", frontPointer, center, tailPointer)
        binarySearch(targetArray: array, target: target, frontPointer: center+1, tailPointer: tailPointer-1)
    } else if ((frontPointer+1) == center) {
        return -1
    }
    return -2
}

let result = binarySearch(targetArray: array, target: 22, frontPointer: 0, tailPointer: (array.count)-1)
print(result)
