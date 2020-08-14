//
//  fibonacciSearch.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/14/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

let array = [10,22,35,40,45,50,80,82,85,90,100]
var fibNumbers = [Int]()

func fibGenerator(left: Int, right: Int, target: Int) {
    if left == 0 {
        fibNumbers.append(left)
        fibNumbers.append(right)
        fibNumbers.append(right)
        fibGenerator(left: right, right: (left + right), target: target)
    } else {
        let nextNumber = left + right
        if nextNumber >= target {
            fibNumbers.append(nextNumber)
            return
        } else {
            fibNumbers.append(nextNumber)
            fibGenerator(left: right, right: nextNumber, target: target)
        }
    }
}

fibGenerator(left: 0, right: 1, target: array.count)
print(fibNumbers)
