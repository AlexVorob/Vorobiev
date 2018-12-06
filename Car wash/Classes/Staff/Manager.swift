//
//  Manager.swift
//  Car wash
//
//  Created by Student on 11/13/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Manager<ProcessedObject: MoneyGiver & Statable>: Staff<ProcessedObject> {

    override func process(object: ProcessedObject) {
        self.receiveMoney(from: object)
    }
    
    override func completeProcessing(object: ProcessedObject) {
        object.state = .available
        if self.countQueueObjects == 0 {
            self.state = .waitForProcessing
        } else {
            super.finishProcessing()
        }
    }
}
