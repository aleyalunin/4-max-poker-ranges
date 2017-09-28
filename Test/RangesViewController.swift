//
//  ViewController.swift
//  ranges-test
//
//  Created by Alexander on 31/08/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import Cocoa

class RangesViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRange()
    }
    
    var numberOfPlayers: Int = 4 {
        didSet {
            updateRange()
        }
    }
    var numberOfBlinds: Int = 10 {
        didSet {
            updateRange()
        }
    }
    
    
    @IBAction func numberOfPlayersSelected(_ sender: NSButton) {
        if let num = Int(sender.title) {
            numberOfPlayers = num
        }
    }
    
    @IBAction func numberOfBlindsSelected(_ sender: NSButton) {
        if let num = Int(sender.title) {
            numberOfBlinds = num
        }
    }
    
    func updateRange() {
        let name = String(numberOfPlayers) + "-" + String(numberOfBlinds)
        imageView.image = NSImage(named: name)
    }
    
}


