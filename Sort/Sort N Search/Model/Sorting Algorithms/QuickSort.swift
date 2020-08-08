//
//  QuickSort.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/7/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

var array = [Float]()

func quickSort(targetArray: [Float], frontPointer: Int, endPointer: Int) {
    array = targetArray
    
    if frontPointer == endPointer {
        return
    } else if endPointer < frontPointer {
        return
    }
    
    let pivot = array[endPointer]
    var jIndex = frontPointer
    var iIndex = frontPointer-1
    
    for _ in (0...(endPointer-1)) {
        if jIndex < (array.count-1) {
            if array[jIndex] < pivot {
                iIndex += 1
                let tempIValue = array[iIndex]
                array[iIndex] = array[jIndex]
                array[jIndex] = tempIValue
                
            }
            jIndex += 1
        }
    }
    let finalPivotLocation = array[iIndex+1]
    array[iIndex+1] = pivot
    array[endPointer] = finalPivotLocation
    
    if (endPointer - 1 != frontPointer) {
        quickSort(targetArray: array, frontPointer: frontPointer, endPointer: iIndex)
        quickSort(targetArray: array, frontPointer: iIndex+2, endPointer: endPointer)
    }
}

var testArray = [Float]()
for _ in 0 ... 5 {
    for _ in 0...1000 {
        testArray.append(Float.random(in: -1000 ... 1000))
    }
    quickSort(targetArray: testArray, frontPointer: 0, endPointer: testArray.count-1)
    let varifiedSortedTest = testArray.sorted()
    if array != varifiedSortedTest {
        print("failed")
        print("original", testArray)
        print("varified", varifiedSortedTest)
        print("array", array)
    }
}
print("Finished")
