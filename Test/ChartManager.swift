//
//  ChartManager.swift
//  Test
//
//  Created by Alexander on 28/08/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class ChartManager {
    
    private var chart = [
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0]
    ]
    
    private var rankMap = [
        "A":0,
        "K":1,
        "Q":2,
        "J":3,
        "T":4,
        "9":5,
        "8":6,
        "7":7,
        "6":8,
        "5":9,
        "4":10,
        "3":11,
        "2":12
    ]
    
    func getChart(range: String) -> [[Int]] {
        resetChart()
        
        let split = range.components(separatedBy: ", ")
        let hands = split[1].components(separatedBy: " ")
        
        for hand in hands {
            if (hand == "Any-two" || hand == "Any") {
                selectAllHands()
                return chart
            }
            
            if hand[0] == hand[1] {
                if let rank = rankMap[hand[0]] {
                    selectPairs(rank: rank)
                }
            }
            
            if hand.contains("x+") {
                var i = rankMap[hand[0]]!
                while i >= 0 {
                    selectColumnDown(col: i, row: 12)
                    selectRowAcross(col: 12, row: i)
                    i -= 1
                }
            }
            
            if hand.contains("-") {
                selectSuitedRange(col1: rankMap[hand[1]]!, col2: rankMap[hand[0]]!, row1: rankMap[hand[5]]!, row2: rankMap[hand[4]]!)
            } else {
                
                if hand.contains("s") {
                    if hand.contains("s+") {
                        selectSuitedHands(col: rankMap[hand[1]]!, row: rankMap[hand[0]]!)
                    } else {
                        selectSingleHand(col: rankMap[hand[1]]!, row: rankMap[hand[0]]!)
                    }
                }
                if hand.contains("o") {
                    if hand.contains("o+") {
                        selectOffSuitHands(col: rankMap[hand[0]]!, row: rankMap[hand[1]]!)
                    } else {
                        selectSingleHand(col: rankMap[hand[0]]!, row: rankMap[hand[1]]!)
                    }
                }
            }
        }
        
        return chart
    }
    
    
    private func resetChart() {
        for i in 0...12 {
            for j in 0...12 {
                chart[i][j] = 0
            }
        }
    }
    
    private func selectAllHands() {
        for i in 0...12 {
            for j in 0...12 {
                chart[i][j] = 1
            }
        }
    }
    
    private func selectPairs(rank: Int) {
        var i = rank
        while i >= 0 {
            chart[i][i] = 1
            i -= 1
        }
    }
    
    private func selectColumnDown(col: Int, row: Int) {
        for i in 0...row {
            chart[i][col] = 1
        }
    }
    
    private func selectRowAcross(col: Int, row: Int) {
        for i in 0...col {
            chart[row][i] = 1
        }
    }
    
    private func selectSuitedHands(col: Int, row: Int) {
        var i = col
        while i > row {
            chart[row][i] = 1
            i -= 1
        }
    }
    
    private func selectSuitedRange(col1: Int, col2: Int, row1: Int, row2: Int) {
        var i = col2
        while i >= col1 {
            var j = row2
            while i >= row1 {
                chart[j][i] = 1
                j -= 1
            }
            i -= 1
        }
    }
    
    private func selectOffSuitHands(col: Int, row: Int){
        var i = row
        while i > col {
            chart[i][col] = 1
            i -= 1
        }
    }
    
    private func selectSingleHand(col: Int, row: Int){
        chart[row][col] = 1
    }
    
}
