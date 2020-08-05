//
//  InsertionSort.swift
//  Sort
//
//  Created by Álvaro Santillan on 8/4/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation
import SpriteKit

class InsertionSort {    
    var array = [1,2,1,2,1,2,1,2,1]

    func insertionSort() {
        for (i, _) in array.enumerated() {
            var j = i - 1
            var ii = i
            while j != -1 && ii != -1 && array[ii] < array[j] {
                let tempJ = array[j]
                array[j] = array[ii]
                array[ii] = tempJ
                j = j - 1
                ii = ii - 1
            }
        }
    }

    insertionSort()
    print(array)
}
