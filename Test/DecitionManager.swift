//
//  DecitionManager.swift
//  Test
//
//  Created by Alexander on 28/08/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Foundation

class DecisionManager {
    
    private var chm = ChartManager()
    
    
    func getDecisionChart(numberOfPlayers: Int,
                          decision: Decision,
                          pusherPosition: Position,
                          callerPosition: Position?,
                          overCallerPosition: Position?,
                          numberOfBlinds: Int) -> [[Int]]? {
        
        guard numberOfPlayers >= 2 || numberOfPlayers <= 4 else {
            print("number of players is not available")
            return nil
        }
        guard numberOfBlinds >= 1 || numberOfBlinds <= 10 else {
            print("stack size is not available")
            return nil
        }
        
        var range: String?
        
        // getting range
        if let data = readJson(fileName: "chartsData") {
            for (key, value) in data {
                if key == String(describing: numberOfPlayers) {
                     if let decisions = value as? [String: Dictionary<String, Any>] {
                        for (key, value) in decisions {
                            if key == decision.rawValue {
                                if let pusherPos = value as? [String: Dictionary<String, Any>] {
                                    for (key, value) in pusherPos {
                                        if key == pusherPosition.rawValue {
                                            if decision == .Push {
                                                if let blinds = value as? [String: String] {
                                                    for (key, value) in blinds {
                                                        if key == String(numberOfBlinds) + "BB" {
                                                            range = value
                                                        }
                                                    }
                                                }
                                            } else if decision == .Call {
                                                if let callerPos = value as? [String: Dictionary<String, Any>] {
                                                    for (key, value) in callerPos {
                                                        if key == callerPosition?.rawValue {
                                                            if let blinds = value as? [String: String] {
                                                                for (key, value) in blinds {
                                                                    if key == String(numberOfBlinds) + "BB" {
                                                                        range = value
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            } else if decision == .OverCall {
                                                if let callerPos = value as? [String: Dictionary<String, Any>] {
                                                    for (key, value) in callerPos {
                                                        if key == callerPosition?.rawValue {
                                                            if let overCallerPos = value as? [String: Dictionary<String, Any>] {
                                                                for (key, value) in overCallerPos {
                                                                    if key == overCallerPosition?.rawValue {
                                                                        if let blinds = value as? [String: String] {
                                                                            for (key, value) in blinds {
                                                                                if key == String(numberOfBlinds) + "BB" {
                                                                                    range = value
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if let range = range {
            let pushChart = chm.getChart(range: range)
            return pushChart
        }
        return nil
    }
    
    
    private func readJson(fileName: String) -> [String: Any]? {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    return object
                } else if json is [Any] {
                    // json is an array
                    return nil
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
