//
//  Director.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Director: Manager<Accountant> {
    
    override func completeProcessing(object: Accountant) {
        print("\(self.name) take money from Accountant - \(self.money)")
        super.completeProcessing(object: object)
    }
    
    override func finishProcessing() {
        self.state = .available
    }
}
