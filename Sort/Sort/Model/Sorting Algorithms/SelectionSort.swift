//
//  SelectionSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/5/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

var array = [1,1,1,1,1,1,-11]
var currentMinimumValue = 0
var currentMinimumIndex = 0

func selectionSort() {
    for (iIndex, _) in array.enumerated() {
        currentMinimumValue = array[iIndex]
        currentMinimumIndex = iIndex
        for jIndex in (iIndex...(array.count-1)) {
            let jValue = array[jIndex]
            if jValue < currentMinimumValue {
                currentMinimumValue = array[jIndex]
                currentMinimumIndex = jIndex
            }
        }
        let tempIValue = array[iIndex]
        array[iIndex] = array[currentMinimumIndex]
        array[currentMinimumIndex] = tempIValue
    }
}

selectionSort()
print(array)
