//
//  Staff.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: Person {
    
    override var state: ProcessingState {
        get { return atomicState.value }
        set {
            guard self.state != newValue else { return }
            if newValue == .available {
                self.queueObjects.dequeue().do(self.doAsyncWork)
            }
            self.atomicState.value = newValue
            self.notify(state: newValue)
        }
    }
    
    public var countQueueObjects: Int {
        return self.queueObjects.count
    }
    
    let name: String
    let queueObjects = Queue<ProcessedObject>()
    
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
        self.repeatQueueProcessing()
    }

    func doAsyncWork(object: ProcessedObject) {
        self.atomicState.modify {
            if $0 == .available {
                $0 = .busy
                self.asyncWork(object: object)
            } else {
                self.queueObjects.enqueue(value: object)
            }
        }
    }
    
    private func asyncWork(object: ProcessedObject) {
        self.queue.asyncAfter(deadline: .after(interval: .random(in: 0.0...1.0))) {
            self.process(object: object)
            self.completeProcessing(object: object)
            self.finishProcessing()
        }
    }
    
    private func repeatQueueProcessing() {
        if self.countQueueObjects == 0 {
            self.state = .waitForProcessing
        } else {
            self.queueObjects.dequeue().do(self.asyncWork)
        }
    }
}
