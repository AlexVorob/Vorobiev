//
//  Accountant.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Accountant: Manager<Washer> {
    
    override func finishProcessing() {
        print("\(self.name) took money from Washer! - \(self.money)")
        if self.countQueueObjects == 0 {
            self.state = .waitForProcessing
        } else {
            super.finishProcessing()
        }
    }
}
