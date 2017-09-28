//
//  Card.swift
//  Test
//
//  Created by Alexander on 28/08/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

struct Card {
    
    enum Suit: String {
        case spades = "spades", hearts = "hearts", diamonds = "diamonds", clubs = "clubs"
    }
    
    enum Rank: Int {
        case Ace = 0, King = 1, Queen = 2, Jack = 3, Ten = 4, Nine = 5, Eight = 6, Seven = 7, Six = 8, Five = 9, Four = 10, Three = 11, Two = 12
    }
    
    let rank: Rank, suit: Suit
    
}
