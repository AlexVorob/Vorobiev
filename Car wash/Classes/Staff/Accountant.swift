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
        self.state = .waitForProcessing
    }
}
