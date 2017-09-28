//
//  ViewController.swift
//  Test
//
//  Created by Alexander on 28/08/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Cocoa


enum Decision: String {
    case Fold = "Fold", Push = "Push", Call = "Call", OverCall = "OverCall"
}

enum Position: String {
    case CO = "CO", BU = "BU", SB = "SB", BB = "BB"
}


class ChartViewController: NSViewController {
    
    
    var dm = DecisionManager()
    
    @IBOutlet weak var pusherCO: NSButton!
    @IBOutlet weak var pusherBU: NSButton!
    @IBOutlet weak var pusherSB: NSButton!
    
    @IBOutlet weak var callerBU: NSButton!
    @IBOutlet weak var callerSB: NSButton!
    @IBOutlet weak var callerBB: NSButton!
    
    @IBOutlet weak var overCallerSB: NSButton!
    @IBOutlet weak var overCallerBB: NSButton!
    
    @IBOutlet weak var pusherBlock: NSStackView!
    @IBOutlet weak var callerBlock: NSStackView!
    @IBOutlet weak var overCallerBlock: NSStackView!
    
    @IBOutlet weak var overCallButton: NSButton!
    @IBOutlet weak var callButton: NSButton!
    
    
    @IBAction func decisionSelected(_ sender: NSButton) {
        switch sender.title {
        case "PUSH":
            decision = .Push
        case "CALL":
            decision = .Call
        case "OVER":
            decision = .OverCall
        default:
            return
        }
    }
    
    @IBAction func numberOfPlayersSelected(_ sender: NSButton) {
        if let num = Int(sender.title) {
            numberOfPlayers = num
        }
    }
    
    @IBAction func pusherPositionSelected(_ sender: NSButton) {
        switch sender.title {
        case "CO":
            pusher = .CO
        case "BU":
            pusher = .BU
        case "SB":
            pusher = .SB
        default:
            return
        }
    }
    
    @IBAction func callerPositionSelected(_ sender: NSButton) {
        switch sender.title {
        case "BU":
            caller = .BU
        case "SB":
            caller = .SB
        case "BB":
            caller = .BB
        default:
            return
        }
    }
    
    @IBAction func overCallerPositionSelected(_ sender: NSButton) {
        switch sender.title {
        case "SB":
            overCaller = .SB
        case "BB":
            overCaller = .BB
        default:
            return
        }
    }
    
    @IBAction func numberOfBlindsSelected(_ sender: NSButton) {
        if let num = Int(sender.title) {
            numberOfBlinds = num
        }
    }
    
    var decision: Decision = .Push {
        willSet {
            switch newValue {
            case .Push:
                callerBlock.isHidden = true
                overCallerBlock.isHidden = true
            case .Call:
                callerBlock.isHidden = false
                overCallerBlock.isHidden = true
            case .OverCall:
                callerBlock.isHidden = false
                overCallerBlock.isHidden = false
            default:
                return
            }
        }
        didSet {
            let temp = numberOfPlayers
            numberOfPlayers = temp
        }
    }
    
    var numberOfPlayers: Int = 4 {
        willSet {
            switch newValue {
            case 4:
                overCallButton.isHidden = false
                pusherCO.isHidden = false
                pusherBU.isHidden = false
                if decision == .OverCall {
                    pusherSB.isHidden = true
                } else {
                    pusherSB.isHidden = false
                }
                pusherCO.state = NSControlStateValueOn
                pusher = .CO
            case 3:
                overCallButton.isHidden = false
                pusherCO.isHidden = true
                pusherBU.isHidden = false
                if decision == .OverCall {
                    pusherSB.isHidden = true
                } else {
                    pusherSB.isHidden = false
                }
                pusherBU.state = NSControlStateValueOn
                pusher = .BU
            case 2:
                overCallButton.isHidden = true
                if decision == .OverCall {
                    callButton.state = NSControlStateValueOn
                    decision = .Call
                }
                pusherCO.isHidden = true
                pusherBU.isHidden = true
                pusherSB.isHidden = false
                pusherSB.state = NSControlStateValueOn
                pusher = .SB
            default:
                return
            }
        }
    }
    
    var pusher: Position = .CO {
        willSet {
            switch newValue {
            case .CO:
                callerBU.isHidden = false
                callerSB.isHidden = false
                if decision == .OverCall {
                    callerBB.isHidden = true
                } else {
                    callerBB.isHidden = false
                }
                callerBU.state = NSControlStateValueOn
                caller = .BU
            case .BU:
                callerBU.isHidden = true
                callerSB.isHidden = false
                if decision == .OverCall {
                    callerBB.isHidden = true
                } else {
                    callerBB.isHidden = false
                }
                callerSB.state = NSControlStateValueOn
                caller = .SB
            case .SB:
                callerBU.isHidden = true
                callerSB.isHidden = true
                callerBB.isHidden = false
                callerBB.state = NSControlStateValueOn
                caller = .BB
            default:
                return
            }
        }
    }
    
    var caller: Position = .BU {
        willSet {
            switch newValue {
            case .BU:
                overCallerSB.isHidden = false
                overCallerBB.isHidden = false
                overCallerSB.state = NSControlStateValueOn
                overCaller = .SB
            case .SB:
                overCallerSB.isHidden = true
                overCallerBB.isHidden = false
                overCallerBB.state = NSControlStateValueOn
                overCaller = .BB
            case .BB:
                overCaller = nil
            default:
                return
            }
        }
    }
    
    var overCaller: Position? {
        didSet {
            DispatchQueue.main.async {
                self.updateChart()
            }
        }
    }
    
    var numberOfBlinds: Int = 10 {
        didSet {
            DispatchQueue.main.async {
                self.updateChart()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPlayers = 4
        
        if let theLabel = self.view.viewWithTag(1) as? NSTextField {
            theLabel.backgroundColor = .yellow
        }
        
    }
    
    func updateChart() {
        let chart = dm.getDecisionChart(numberOfPlayers: numberOfPlayers, decision: decision, pusherPosition: pusher, callerPosition: caller, overCallerPosition: overCaller, numberOfBlinds: numberOfBlinds)
        
        if let chart = chart {
            var counter = 1
            for a in 0...chart.count-1 {
                for b in 0...chart.count-1 {
                    if let theLabel = self.view.viewWithTag(counter) as? NSTextField {
                        if chart[a][b] == 1 {
                            theLabel.backgroundColor = .green
                        } else {
                            theLabel.backgroundColor = NSColor(calibratedRed: 0.82, green: 0.82, blue: 0.82, alpha: 1.0)
                        }
                    }
                    counter += 1
                }
            }
        }
    }
    
}

