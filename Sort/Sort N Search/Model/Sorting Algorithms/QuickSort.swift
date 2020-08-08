//
//  QuickSort.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/7/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

//var array = [5,0,1,8,7] // works
//var array = [2,1,3,1,3,2,8,67,3,1] // works
//var array = [2,1] // works
//var array = [6,7,5,8] // works
//var array = [6,7,5] // works/
//var array = [6,7] // works
//var array = [7,2,1,8,6,3,5,4]
var array = [Float]()

func quickSort(targetArray: [Float], frontPointer: Int, endPointer: Int) {
    array = targetArray
//    print("before", array, frontPointer, endPointer)
    
    if frontPointer == endPointer {
//        print("if One", frontPointer, endPointer)
        return
    } else if endPointer < frontPointer {
//        print("if Two", frontPointer, endPointer)
        return
    }
    
    let pivot = array[endPointer]
    var jIndex = frontPointer
    var iIndex = frontPointer-1
    
    for _ in (0...(endPointer-1)) {
        if jIndex < (array.count-1) {
            if array[jIndex] >= pivot {
                jIndex += 1
            } else if array[jIndex] < pivot {
                iIndex += 1
                let tempIValue = array[iIndex]
                array[iIndex] = array[jIndex]
                array[jIndex] = tempIValue
                jIndex += 1
            }
        }
    }
    let finalPivotLocation = array[iIndex+1]
    array[iIndex+1] = pivot
    array[endPointer] = finalPivotLocation
//    print("after", array, frontPointer, endPointer)
    
    if (endPointer - 1 != frontPointer) {
        quickSort(targetArray: array, frontPointer: frontPointer, endPointer: iIndex)
//        if endPointer >= pivot {
        quickSort(targetArray: array, frontPointer: iIndex+2, endPointer: endPointer)
//        } else {
//            print("not calling", frontPointer, endPointer)
//        }
    } else {
//        print("sdf")
    }
}

//quickSort(targetArray: t, frontPointer: 0, endPointer: array.count-1)
//

var testArray = [Float]()
for _ in 0 ... 100 {
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
