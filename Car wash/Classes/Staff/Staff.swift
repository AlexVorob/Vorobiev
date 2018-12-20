//
//  Staff.swift
//  Car wash 
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: Person, Processable {

    override var state: ProcessingState {
        get { return atomicState.value }
        set {
            self.atomicState.modify {
                $0 = newValue
                self.notify(state: newValue)
            }
        }
    }
    
    let name: String
    private let queue: DispatchQueue
    
    init (
        name: String,
        queue: DispatchQueue = .background
    ) {
        self.name = name
        self.queue = queue
    }
    
    func process(object: ProcessedObject) {
        
    }
    
    func completeProcessing(object: ProcessedObject) {
        
    }
    
    func finishProcessing() {
        //self.state = .waitForProcessing
    }

    func processObject(processObject: ProcessedObject) {
        self.atomicState.modify {
            if $0 == .available {
                $0 = .busy
                queue.asyncAfter(deadline: .after(interval: .random(in: 0.0...1.0))) {
                    self.process(object: processObject)
                    self.completeProcessing(object: processObject)
                    self.finishProcessing()
                }
            }
        }
    }
}
